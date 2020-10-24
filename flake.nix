{
  description = "Funkwhale";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-20.03;

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
      funkwhale = 
      let
        release = "0.20.0";
        srcs = {
          api = final.fetchurl {
            url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31311/artifacts/download;
            name =  "api.zip";
            sha256 = "1v8v5rha21ksdqnj73qkvc35mxal82hypxa5gnf82y1cjk2lp4w7";
          };
          frontend = final.fetchurl {
            url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31308/artifacts/download;
            name =  "frontend.zip";
            sha256 = "02pc6j83sn5l8wz7i2r649pff3gs5021isx9d5l9xsb5cndkq0b4";
          };
        };
      in with final; (stdenv.mkDerivation {
          name = "funkwhale";
          version = "${release}";
          src = srcs.api;
          nativeBuildInputs = [ unzip ];
          postPatch = ''
            substituteInPlace requirements/base.txt \
            --replace "django-cleanup==3.2.0" django-cleanup
          '';

          installPhase = ''
            mkdir $out
            cp -R ./* $out
            unzip ${srcs.frontend} -d $out
            mv $out/front/ $out/front_tmp
            mv $out/front_tmp/dist $out/front
            rmdir $out/front_tmp
          '';

          meta = with stdenv.lib; {
            description = "A modern, convivial and free music server";
            homepage = https://funkwhale.audio/;
            license = licenses.agpl3;
            platforms = platforms.linux;
            maintainers = with maintainers; [ mmai ];
          };
        });
    };

    # funkwhale package
    # defaultPackage.x86_64-linux =
    #   with import nixpkgs { system = "x86_64-linux"; };
    #   (import ./pkg.nix) { stdenv, fetchurl, unzip }

    packages = forAllSystems (system: {
      inherit (nixpkgsFor.${system}) funkwhale;
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.funkwhale);


    # funkwhale service module
    nixosModule = (import ./module.nix);

  };
}
