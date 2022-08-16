{
  description = "Funkwhale";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

  outputs = { self, nixpkgs }:
  let
    version = "1.2.7";
    systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system); 
    # Memoize nixpkgs for different platforms for efficiency.
    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      }
    );
  in {
    overlay = final: prev: {

      funkwhale-front = with final; stdenv.mkDerivation {
          pname = "funkwhale-front";
          inherit version;

          nativeBuildInputs = [ pkgs.unzip ];
          unpackCmd = "unzip $curSrc";

          src = fetchurl {
            url =
              "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${version}/download?job=build_front";
            sha256 = "WheBYJOdQYmqyw0bOs10PfIz89NNc+a+3rVzs09brsc=";
          };

          installPhase = ''
            mkdir $out
            cp -R ./dist/* $out
          '';
        };

      funkwhale = with final; (stdenv.mkDerivation {
          pname = "funkwhale";
          inherit version;
          src = fetchurl {
            url = "https://dev.funkwhale.audio/funkwhale/funkwhale/-/archive/${version}/funkwhale-${version}.tar.bz2";
            sha256 = "sha256-UnOz8S2OKtHJM/Lnx9Ud+Y6XziXCtZb9Qs6MqdfkdQU=";
          };

          installPhase = ''
            sed "s|env -S|env|g" -i front/scripts/*.sh
            mkdir $out
            cp -R ./* $out
          '';

          meta = with lib; {
            description = "A modern, convivial and free music server";
            homepage = https://funkwhale.audio/;
            license = licenses.agpl3;
            platforms = platforms.linux;
            maintainers = with maintainers; [ mmai ];
          };
      });

      # ------------- new packages -------------------

      requests-http-message-signatures = with final; with pkgs.python3.pkgs; ( buildPythonPackage rec {
        pname = "requests-http-message-signatures";
        version = "0.3.1";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-AjW7XNP0p9ZZZF4qyTfacnkTIUNOd1cPfiEELlEIINo=";
        };
        propagatedBuildInputs = [ requests cryptography ];
        doCheck = false;
      });


      django-cache-memoize = with final; with pkgs.python3.pkgs; ( buildPythonPackage rec {
        pname = "django-cache-memoize";
        version = "0.1.10";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-Y+j6okWkHA262EOAfp8hpuWeuo5uUN8xD99khaZ0mEM=";
        };
        propagatedBuildInputs = [];
        doCheck = false;
      });

      # ------------- nixpkgs overrides -------------------

      ioredis = with final; with pkgs.python3.pkgs; ( buildPythonPackage rec {
        pname = "aioredis";
        version = "1.3.1";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-FfivMLBEx3Gu5nh+XsJGlMBIGEx7nlTDtgx1CkuTJzo=";
        };
        propagatedBuildInputs = [ async-timeout hiredis ];
        doCheck = false;
      });

      channels-redis = with final; with pkgs.python3.pkgs; ( buildPythonPackage rec {
        pname = "channels_redis";
        version = "3.4.0";
        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-Xf/UzBYXQSW9QEP8j+dGLKdAPPgB1Zqfp0EO0QH6alc=";
        };
        propagatedBuildInputs = [ channels ioredis msgpack ];
        doCheck = false;
      });


    };


    packages = forAllSystems (system: {
      inherit (nixpkgsFor.${system}) funkwhale;
      inherit (nixpkgsFor.${system}) funkwhale-front;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.funkwhale);


    # funkwhale service module
    nixosModule = (import ./module.nix);

  };
}
