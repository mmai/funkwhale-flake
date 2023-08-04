{
  description = "Funkwhale";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }:
  let
    version = "1.3.1";
    systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system); 
    # Memoize nixpkgs for different platforms for efficiency.
    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      }
    );
  in {
    overlays.default = final: prev: {

      funkwhale-front = with final; stdenv.mkDerivation {
          pname = "funkwhale-front";
          inherit version;

          nativeBuildInputs = [ pkgs.unzip ];
          unpackCmd = "unzip $curSrc";

          src = fetchurl {
            url =
              "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${version}/download?job=build_front";
            sha256 = "sha256-nCawQ/qIqJk7JacAN2JBI5vsSjHDRyXGMJXQPxioKoI=";
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
            sha256 = "sha256-Fu+N4yOM4h5b3B7U+D7r/0QZGQm8HPhN4jKmYOARN7g=";
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

      django-versatileimagefield = with final; with pkgs.python3.pkgs; ( buildPythonPackage rec {
        pname = "django-versatileimagefield";
        version = "3.0";

        src = fetchPypi {
          inherit pname version;
          hash = "sha256-FlHbLtNthDz7F4jyYBRyopPZuoZyk2m29uVZERI1esc=";
        };
        propagatedBuildInputs = [ django pillow python-magic ];

        nativeCheckInputs = [ django ];

        # tests not included with pypi release
        doCheck = false;

        pythonImportsCheck = [ "versatileimagefield" ];

        meta = with lib; {
          description = "Replaces django's ImageField with a more flexible interface";
          homepage = "https://github.com/respondcreate/django-versatileimagefield/";
          license = licenses.mit;
          maintainers = with maintainers; [ mmai ];
        };
      });

    };


    packages = forAllSystems (system: {
      inherit (nixpkgsFor.${system}) funkwhale;
      inherit (nixpkgsFor.${system}) funkwhale-front;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.funkwhale);


    # funkwhale service module
    nixosModules.default = (import ./module.nix);

  };
}
