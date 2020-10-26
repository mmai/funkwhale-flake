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
      funkwhale = with final; (stdenv.mkDerivation {
          name = "funkwhale";
          version = "1.0.0";
          src = final.fetchurl {
            url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/archive/1.0/funkwhale-1.0.tar.bz2
            sha256 = "1v8v5rha21ksdqnj73qkvc35mxal82hypxa5gnf82y1cjk2lp4w7";
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

      django-cacheops = with final; ( buildPythonPackage rec {
        pname = "django-cacheops";
        version = "5.1";

        src = fetchPypi {
          inherit pname version;
          sha256 = "056xiijig8r2nxrd9gj1nki168422rsh8ap5vkbr9zyp1mzvbpn3";
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

    };

    packages = forAllSystems (system: {
      inherit (nixpkgsFor.${system}) funkwhale;
      inherit (nixpkgsFor.${system}) django-cacheops;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.funkwhale);


    # funkwhale service module
    nixosModule = (import ./module.nix);

  };
}
