{config, lib, pkgs, ...}:

with lib;

let

  pythonPackagesOverrides = self: super: {
  };


  pythonEnv = (pkgs.python3.override { packageOverrides = pythonPackagesOverrides; }).withPackages (ps: [ # default is python3.10 on nixos 23.05
  # pythonEnv = pkgs.python3.withPackages (ps: [
    # --- packages not in nixpkgs
    pkgs.requests-http-message-signatures
    pkgs.django-cache-memoize # --- packages from nixpkgs
    ps.PyLD
    ps.aiohttp
    ps.aioredis
    ps.arrow
    ps.astroid
    ps.autobahn
    ps.av
    # ps.backports-zoneinfo # fails with : backports-zoneinfo-0.2.1 not supported for interpreter python3.10
    pkgs.python311Packages.backports-zoneinfo
    ps.bleach
    ps.boto3
    ps.cached-property
    ps.celery
    ps.channels
    ps.channels-redis
    ps.click
    ps.daphne
    ps.dill
    ps.django
    ps.django-allauth
    ps.django-auth-ldap
    ps.django-cacheops
    ps.django-cleanup
    ps.django-cors-headers
    ps.django-dynamic-preferences
    ps.django-filter
    ps.django-oauth-toolkit
    ps.django-redis
    ps.django-storages
    # ps.django-versatileimagefield # fails with ERROR: Could not find a version that satisfies the requirement Django>=3.0 (
    pkgs.django-versatileimagefield
    ps.django_environ
    ps.django_taggit
    ps.djangorestframework
    ps.dj-rest-auth
    ps.drf-spectacular
    ps.feedparser
    ps.gunicorn
    ps.isort
    ps.kombu
    ps.lazy-object-proxy
    ps.ldap
    ps.markdown
    ps.musicbrainzngs
    ps.mutagen
    ps.pendulum
    ps.persisting-theory
    ps.pillow
    ps.psycopg2
    ps.pyacoustid
    ps.pydub
    ps.pylint
    ps.pylint-django
    ps.pylint-plugin-utils
    ps.pyopenssl
    ps.python_magic
    ps.pytz
    ps.redis 
    ps.requests
    ps.service-identity
    ps.toml
    ps.tomlkit
    ps.unicode-slugify
    ps.unidecode
    ps.uvicorn
    ps.uvloop ps.httptools ps.websockets # additonal packages for uvicorn (to mimic `pip install uvicorn[standard]`) needed for websockets
    ps.watchdog
  ]);
  cfg              = config.services.funkwhale;
  databasePassword = if (cfg.database.passwordFile != null) 
    then builtins.readFile cfg.database.passwordFile
    else cfg.database.password;
  databaseUrl = if (cfg.database.createLocally && cfg.database.socket != null) 
    then "postgresql:///${cfg.database.name}?host=${cfg.database.socket}" 
    else "postgresql://${cfg.database.user}:${databasePassword}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";

  funkwhaleEnvironment = [
    "FUNKWHALE_URL=${cfg.hostname}"
    "FUNKWHALE_HOSTNAME=${cfg.hostname}"
    "FUNKWHALE_PROTOCOL=${cfg.protocol}"
    "EMAIL_CONFIG=${cfg.emailConfig}"
    "DEFAULT_FROM_EMAIL=${cfg.defaultFromEmail}"
    "REVERSE_PROXY_TYPE=nginx"
    "DATABASE_URL=${databaseUrl}"
    "CACHE_URL=redis://localhost:${toString config.services.redis.servers."".port}/0"
    "MEDIA_ROOT=${cfg.api.mediaRoot}"
    "STATIC_ROOT=${cfg.api.staticRoot}"
    "DJANGO_SECRET_KEY=(cat ${cfg.api.djangoSecretKeyFile})"
    "MUSIC_DIRECTORY_PATH=${cfg.musicPath}"
    "MUSIC_DIRECTORY_SERVE_PATH=${cfg.musicPath}"
    "FUNKWHALE_FRONTEND_PATH=${cfg.dataDir}/front"
    "FUNKWHALE_PLUGINS=funkwhale_api.contrib.scrobbler"
    "TYPESENSE_API_KEY=${cfg.typesenseKey}"
  ];
  funkwhaleEnvFileData = builtins.concatStringsSep "\n" funkwhaleEnvironment;
  funkwhaleEnvScriptData = builtins.concatStringsSep " " funkwhaleEnvironment;

  funkwhaleEnvFile = pkgs.writeText "funkwhale.env" funkwhaleEnvFileData;
  funkwhaleEnv = {
    ENV_FILE = "${funkwhaleEnvFile}";

    # XXX : copié de api/config/asgi.py ( sinon erreur lors du lancement gunicorn ) 
    DJANGO_SETTINGS_MODULE = "config.settings.production";
    ASGI_THREADS = "5";
  };
in 
  {

    options = {
      services.funkwhale = {
        enable = mkEnableOption "funkwhale";

        user = mkOption {
          type = types.str;
          default = "funkwhale";
          description = "User under which Funkwhale is ran.";
        };

        group = mkOption {
          type = types.str;
          default = "funkwhale";
          description = "Group under which Funkwhale is ran.";
        };

        database = {
          host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Database host address.";
          };

          port = mkOption {
            type = types.int;
            default = 5432;
            description = "Database host port.";
          };

          name = mkOption {
            type = types.str;
            default = "funkwhale";
            description = "Database name.";
          };

          user = mkOption {
            type = types.str;
            default = "funkwhale";
            description = "Database user.";
          };

          password = mkOption {
            type = types.str;
            default = "";
            description = ''
              The password corresponding to <option>database.user</option>.
              Warning: this is stored in cleartext in the Nix store!
              Use <option>database.passwordFile</option> instead.
            '';
          };

          passwordFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/keys/funkwhale-dbpassword";
            description = ''
              A file containing the password corresponding to
              <option>database.user</option>.
            '';
          };

          socket = mkOption {
            type = types.nullOr types.path;
            default = "/run/postgresql";
            description = "Path to the unix socket file to use for authentication for local connections.";
          };

          createLocally = mkOption {
            type = types.bool;
            default = true;
            description = "Create the database and database user locally.";
          };
        };

        dataDir = mkOption {
          type = types.str;
          default = "/srv/funkwhale";
          description = ''
            Where to keep the funkwhale data.
          '';
        };

        typesenseKey = mkOption {
          type = types.str;
          default = "my-secret-typesense-key";
          description = ''
            Typesense API key.
          '';
        };

        apiIp = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Funkwhale API IP.
          '';
        };

        webWorkers = mkOption {
          type = types.int;
          default = 1;
          description = ''
            Funkwhale number of web workers.
          '';
        };

        apiPort = mkOption {
          type = types.port;
          default = 5000;
          description = ''
            Funkwhale API Port.
          '';
        };

        frontIp = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Funkwhale Front IP.
          '';
        };

        frontPort = mkOption {
          type = types.port;
          default = 80;
          # default = 8080;
          description = ''
            Funkwhale Front Port.
          '';
        };

        hostname = mkOption {
          type = types.str;
          description = ''
            The definitive, public domain you will use for your instance.
          '';
          example = "funkwhale.yourdomain.net";
        };

        protocol = mkOption {
          type = types.enum [ "http" "https" ];
          default = "https";
          description = ''
            Web server protocol.
          '';
        };

        forceSSL = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Force SSL : put this to 'false' when Let's Encrypt has problems calling 'http:' to check the domain
          '';
        };

        emailConfig = mkOption {
          type = types.str;
          default = "consolemail://";
          description = ''
            Configure email sending. By default, it outputs emails to console instead of sending them.
            See <link xlink:href="https://docs.funkwhale.audio/configuration.html#email-config"/> for details.
          '';
          example = "smtp+ssl://user@:password@youremail.host:465";
        };

        defaultFromEmail = mkOption {
          type = types.str;
          description = ''
            The email address to use to send system emails.
          '';
          example = "funkwhale@yourdomain.net";
        };

        api = {
          mediaRoot = mkOption {
            type = types.str;
            default = "/srv/funkwhale/media";
            description = ''
              Where media files (such as album covers or audio tracks) should be stored on your system.
            '';
          };

          staticRoot = mkOption {
            type = types.str;
            default = "/srv/funkwhale/static";
            description = ''
              Where static files (such as API css or icons) should be compiled on your system.
            '';
          };

          djangoSecretKeyFile = mkOption {
            type = types.str;
            default = "/run/secrets/funkwhale_django_secret";
            description = ''
              File containing the django secret key. Generate one using <command>openssl rand -base64 45</command> for example.
            '';
          };
        };

        musicPath = mkOption {
          type = types.str;
          default = "/srv/funkwhale/music";
          description = ''
            In-place import settings.
          '';
        };

      };
    };

    config = mkIf cfg.enable {
      assertions = [
        { assertion = cfg.database.passwordFile != null || cfg.database.password != "" || cfg.database.socket != null;
          message = "one of services.funkwhale.database.socket, services.funkwhale.database.passwordFile, or services.funkwhale.database.password must be set";
        }
        { assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
          message = "services.funkwhale.database.user must be set to ${cfg.user} if services.funkwhale.database.createLocally is set true";
        }
        { assertion = cfg.database.createLocally -> cfg.database.socket != null;
          message = "services.funkwhale.database.socket must be set if services.funkwhale.database.createLocally is set to true";
        }
        { assertion = cfg.database.createLocally -> cfg.database.host == "localhost";
          message = "services.funkwhale.database.host must be set to localhost if services.funkwhale.database.createLocally is set to true";
        }
      ];

      users.users.funkwhale = mkIf (cfg.user == "funkwhale") {
        group = cfg.group; 
        isSystemUser = true;
      };

      users.groups.funkwhale = mkIf (cfg.group == "funkwhale") {};

      services.postgresql = mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          { name = cfg.database.user;
            ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
          }
        ];
      };

      services.redis.servers."".enable =  true;

      services.nginx = {
        enable = true;
        appendHttpConfig = ''
          upstream funkwhale-api {
            server ${cfg.apiIp}:${toString cfg.apiPort};
          }
          upstream funkwhale-front {
           server ${cfg.frontIp}:${toString cfg.frontPort};
          }
        '';
        virtualHosts = 
        let proxyConfig = ''
          # global proxy conf
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Host $host:$server_port;
          proxy_set_header X-Forwarded-Port $server_port;
          proxy_redirect off;

          # websocket support
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
        withSSL = cfg.protocol == "https";
        in {
          "${cfg.hostname}" = {
            enableACME = withSSL;
            forceSSL = cfg.forceSSL;
            root = "${cfg.dataDir}/front";
          # gzip config is nixos nginx recommendedGzipSettings with gzip_types 
          # from funkwhale doc (https://docs.funkwhale.audio/changelog.html#id5)
            extraConfig = ''
              add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:";
              add_header Referrer-Policy "strict-origin-when-cross-origin";

              gzip on;
              gzip_disable "msie6";
              gzip_proxied any;
              gzip_comp_level 5;
              gzip_types
              application/javascript
              application/vnd.geo+json
              application/vnd.ms-fontobject
              application/x-font-ttf
              application/x-web-app-manifest+json
              font/opentype
              image/bmp
              image/svg+xml
              image/x-icon
              text/cache-manifest
              text/css
              text/plain
              text/vcard
              text/vnd.rim.location.xloc
              text/vtt
              text/x-component
              text/x-cross-domain-policy;
              gzip_vary on;
            '';
            locations = {
              "/api/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api";
              };
              "/" = {
                # proxyPass = "http://funkwhale-front";
                extraConfig = ''
                  add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:; worker-src 'self'";
                  add_header Referrer-Policy "strict-origin-when-cross-origin";
                  add_header Service-Worker-Allowed "/";
                  expires 30d;
                  add_header Pragma public;
                  add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                '';
              };
              "/front/" = {
              # "/front/embed.html" = {
                # proxyPass = "http://funkwhale-front/embed.html";
                alias = "${cfg.dataDir}/front/";
                extraConfig = ''
                  add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:; worker-src 'self'";
                add_header Referrer-Policy "strict-origin-when-cross-origin";
                add_header X-Frame-Options "" always;
                expires 30d;
                add_header Pragma public;
                add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                '';
              };
              "/embed.html" = {
                # proxyPass = "http://funkwhale-front/embed.html";
                extraConfig = ''
                  add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:; worker-src 'self'";
                add_header Referrer-Policy "strict-origin-when-cross-origin";
                add_header X-Frame-Options "" always;
                expires 30d;
                add_header Pragma public;
                add_header Cache-Control "public, must-revalidate, proxy-revalidate";
                '';
              };
              "/federation/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api";
              };
              "/rest/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api/api/subsonic/rest/";
              };
              "/.well-known/" = { 
                extraConfig = proxyConfig;
                proxyPass = "http://funkwhale-api";
              };

              "/media/" = {
                alias = "${cfg.api.mediaRoot}/";
                extraConfig = ''
                add_header Access-Control-Allow-Origin '*';
              add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; object-src 'none'; media-src 'self' data:";
                '';
              };

              "/_protected/media/" = {
                extraConfig = ''
                  internal;
                '';
                alias = "${cfg.api.mediaRoot}/";
              };
              "/_protected/music/" = {
                extraConfig = ''
                  internal;
                '';
                alias = "${cfg.musicPath}/";
              };
              "/staticfiles/".alias = "${cfg.api.staticRoot}/";

              # "/manifest.json" = {
              #   return 302 ${FUNKWHALE_PROTOCOL}://${FUNKWHALE_HOSTNAME}/api/v1/instance/spa-manifest.json;
              # }

            };
          };
        };
      };

      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.api.mediaRoot} 0755 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.api.staticRoot} 0755 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.musicPath} 0755 ${cfg.user} ${cfg.group} - -"
      ];

      systemd.targets.funkwhale = {
        description = "Funkwhale";
        wants = ["funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service"];
      }; 
      systemd.services = 
      let serviceConfig = {
        User = "${cfg.user}";
        WorkingDirectory = "${pkgs.funkwhale}/api";
      };
      in {
        funkwhale-psql-init = mkIf cfg.database.createLocally {
          description = "Funkwhale database preparation";
          after = [ "redis.service" "postgresql.service" ];
          wantedBy = [ "funkwhale-init.service" ];
          before   = [ "funkwhale-init.service" ];
          serviceConfig = {
            User = "postgres";
            ExecStart = '' ${config.services.postgresql.package}/bin/psql \
              -d ${cfg.database.name}  -c 'CREATE EXTENSION IF NOT EXISTS \
              "unaccent";CREATE EXTENSION IF NOT EXISTS "citext";' '';
          };
        };
        # TODO : test if funkwhale version has been updated and if so : regenerate .env links and copy front 
        funkwhale-init = {
          description = "Funkwhale initialization";
          wantedBy = [ "funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service" ];
          before   = [ "funkwhale-server.service" "funkwhale-worker.service" "funkwhale-beat.service" ];
          environment = funkwhaleEnv;
          serviceConfig = {
            User = "${cfg.user}";
            Group = "${cfg.group}";
          };
          script = ''
            ${pythonEnv.interpreter} ${pkgs.funkwhale}/api/manage.py migrate
            ${pythonEnv.interpreter} ${pkgs.funkwhale}/api/manage.py collectstatic --no-input
            echo "#!/bin/sh

            ${funkwhaleEnvScriptData} ${pythonEnv.interpreter} ${pkgs.funkwhale}/api/manage.py \
              createsuperuser" > ${cfg.dataDir}/createSuperUser.sh
            chmod u+x ${cfg.dataDir}/createSuperUser.sh
            chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
            echo "#!/bin/sh

            LIBRARY_ID=\$1
            ${funkwhaleEnvScriptData} ${pythonEnv.interpreter} ${pkgs.funkwhale}/api/manage.py \
              import_files \$LIBRARY_ID '/srv/funkwhale/music/imports' --recursive --noinput --in-place" > ${cfg.dataDir}/importMusic.sh
            chmod u+x ${cfg.dataDir}/importMusic.sh
            chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}

            mkdir -p ${cfg.dataDir}/config
            rm -f ${cfg.dataDir}/config/.env
            ln -s ${funkwhaleEnvFile} ${cfg.dataDir}/config/.env
            rm -f ${cfg.dataDir}/config/.env
            ln -s ${funkwhaleEnvFile} ${cfg.dataDir}/.env

            chmod -R u+rwx ${cfg.dataDir}/front
            rm -rf ${cfg.dataDir}/front
            cp -r ${pkgs.funkwhale-front} ${cfg.dataDir}/front
          '';
        };

        funkwhale-server = {
          description = "Funkwhale application server";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { 
            ExecStart = ''${pythonEnv}/bin/gunicorn config.asgi:application \
              -w ${toString cfg.webWorkers} -k uvicorn.workers.UvicornWorker \
              -b ${cfg.apiIp}:${toString cfg.apiPort}'';
          };
          environment = funkwhaleEnv;

          wantedBy = [ "multi-user.target" ];
        };

        funkwhale-worker = {
          description = "Funkwhale celery worker";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { 
            RuntimeDirectory = "funkwhaleworker"; 
            ExecStart = "${pythonEnv}/bin/celery --app=funkwhale_api.taskapp worker --loglevel=INFO --concurrency=0";
          };
          environment = funkwhaleEnv;

          wantedBy = [ "multi-user.target" ];
        };

        funkwhale-beat = {
          description = "Funkwhale celery beat process";
          partOf = [ "funkwhale.target" ];

          serviceConfig = serviceConfig // { 
            RuntimeDirectory = "funkwhalebeat"; 
            ExecStart = '' ${pythonEnv}/bin/celery --app=funkwhale_api.taskapp beat --loglevel=INFO \
              --schedule="/run/funkwhalebeat/celerybeat-schedule.db"  \
              --pidfile="/run/funkwhalebeat/celerybeat.pid" '';
          };
          environment = funkwhaleEnv;

          wantedBy = [ "multi-user.target" ];
        };

      };

    };

    meta = {
      maintainers = with lib.maintainers; [ mmai ];
    };
  }
