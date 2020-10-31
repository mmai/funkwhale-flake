{
  description = "Funkwhale";

  # inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.09;

  outputs = { self, nixpkgs }:
  let
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

      funkwhale-front = final.stdenv.mkDerivation {
        name = "funkwhale-front";
        src = ./funkwhale-front;
        installPhase = ''
          mkdir $out
          cp -R ./* $out
        '';
      };

      funkwhale = with final; (stdenv.mkDerivation {
          name = "funkwhale";
          version = "1.0.0";
          src = fetchurl {
            url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/archive/1.0/funkwhale-1.0.tar.bz2;
            sha256 = "sha256-ZYPa7hIWk6sZm1QhYlhQog5ZQ3cQAGqhYBys5cMDxvg=";
          };

          installPhase = ''
            mkdir $out
            cp -R ./* $out
          '';

          meta = with stdenv.lib; {
            description = "A modern, convivial and free music server";
            homepage = https://funkwhale.audio/;
            license = licenses.agpl3;
            platforms = platforms.linux;
            maintainers = with maintainers; [ mmai ];
          };
        });

      django-cacheops = with final; with pkgs.python3.pkgs; ( buildPythonPackage rec {
        pname = "django-cacheops";
        version = "5.1";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-1YUc178whzhKH87PqN3bj1UDDu39b98SciW3W8oPmd0=";
        };
        propagatedBuildInputs = [ django redis six funcy ];
        doCheck = false;

        meta = with stdenv.lib; {
          description = "A slick ORM cache with automatic granular event-driven invalidation for Django";
          homepage = "http://github.com/Suor/django-cacheops";
          license = licenses.bsd3;
          maintainers = with maintainers; [ mmai ];
        };
      });

        nodeDependencies = (final.callPackage ./funkwhale-front-node {}).package;
    };

    packages = forAllSystems (system: {
      inherit (nixpkgsFor.${system}) funkwhale;
      inherit (nixpkgsFor.${system}) funkwhale-front;
      inherit (nixpkgsFor.${system}) django-cacheops;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.funkwhale);


    # funkwhale service module
    nixosModule = (import ./module.nix);

  };
}
