{
  description = "Funkwhale";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }:
    let
      version = "1.3.3";
      systems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        }
      );
    in
    {
      overlays.default = final: prev: {

        funkwhale-front = with final; stdenv.mkDerivation {
          pname = "funkwhale-front";
          inherit version;

          nativeBuildInputs = [ pkgs.unzip ];
          unpackCmd = "unzip $curSrc";

          src = fetchurl {
            url =
              "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${version}/download?job=build_front";
            sha256 = "sha256-0DOcTkKKU+REoMTJQW11hrrND88eTQ2+tIuQRzxa0rw=";
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
            sha256 = "sha256-bcJMY0Ndnlq5hKJVYMO/qwckYTZtABhDJem2C9E/zB4=";
          };

          patches = [ ./funkwhale.patch ];

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

        requests-http-message-signatures = with final; with pkgs.python3.pkgs; (buildPythonPackage rec {
          pname = "requests-http-message-signatures";
          version = "0.3.1";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-AjW7XNP0p9ZZZF4qyTfacnkTIUNOd1cPfiEELlEIINo=";
          };
          propagatedBuildInputs = [ requests cryptography ];
          doCheck = false;
        });


        django-cache-memoize = with final; with pkgs.python3.pkgs; (buildPythonPackage rec {
          pname = "django-cache-memoize";
          version = "0.1.10";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-Y+j6okWkHA262EOAfp8hpuWeuo5uUN8xD99khaZ0mEM=";
          };
          propagatedBuildInputs = [ ];
          doCheck = false;
        });

        django-versatileimagefield = with final; with pkgs.python3.pkgs; (buildPythonPackage rec {
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

        # ------------- will be in 23.11
        jsonschema-specifications = with final; with pkgs.python3.pkgs; (buildPythonPackage rec {
          pname = "jsonschema-specifications";
          version = "2023.7.1";
          format = "pyproject";

          disabled = pythonOlder "3.8";

          src = fetchPypi {
            pname = "jsonschema_specifications";
            inherit version;
            hash = "sha256-yRpQQE6Iofa6QGNneOLuCPbiTFYT/kxTrCRXilp/crs=";
          };

          nativeBuildInputs = [
            hatch-vcs
            hatchling
          ];

          propagatedBuildInputs = [
            referencing
          ] ++ lib.optionals (pythonOlder "3.9") [
            importlib-resources
          ];

          nativeCheckInputs = [
            pytestCheckHook
          ];

          pythonImportsCheck = [
            "jsonschema_specifications"
          ];

          meta = with lib; {
            description = "Support files exposing JSON from the JSON Schema specifications";
            homepage = "https://github.com/python-jsonschema/jsonschema-specifications";
            license = licenses.mit;
            maintainers = with maintainers; [ SuperSandro2000 ];
          };
        });

        referencing = with final; with pkgs.python3.pkgs; (buildPythonPackage rec {
          pname = "referencing";
          version = "0.30.0";
          format = "pyproject";

          disabled = pythonOlder "3.7";

          src = fetchFromGitHub {
            owner = "python-jsonschema";
            repo = "referencing";
            rev = "refs/tags/v${version}";
            fetchSubmodules = true;
            hash = "sha256-nJSnZM3gg2+yfFAnOJzzXsmIEQdNf5ypt5R0O60NphA=";
          };

          SETUPTOOLS_SCM_PRETEND_VERSION = version;

          nativeBuildInputs = [
            hatch-vcs
            hatchling
          ];

          propagatedBuildInputs = [
            attrs
            rpds-py
          ];

          nativeCheckInputs = [
            jsonschema
            pytest-subtests
            pytestCheckHook
          ];

          # avoid infinite recursion with jsonschema
          doCheck = false;

          passthru.tests.referencing = self.overridePythonAttrs { doCheck = true; };

          pythonImportsCheck = [
            "referencing"
          ];

          meta = with lib; {
            description = "Cross-specification JSON referencing";
            homepage = "https://github.com/python-jsonschema/referencing";
            changelog = "https://github.com/python-jsonschema/referencing/blob/${version}/CHANGELOG.rst";
            license = licenses.mit;
            maintainers = with maintainers; [ fab ];
          };
        });

        rpds-py = with final; with pkgs.python3.pkgs; (buildPythonPackage rec {
          pname = "rpds-py";
          version = "0.9.2";
          format = "pyproject";

          disabled = pythonOlder "3.8";

          src = fetchPypi {
            pname = "rpds_py";
            inherit version;
            hash = "sha256-jXDo8UkA8mV8JJ6k3vljvthqKbgfgfW3a1qSFWgN6UU=";
          };

          cargoDeps = rustPlatform.fetchCargoTarball {
            inherit src;
            name = "${pname}-${version}";
            hash = "sha256-2LiQ+beFj9+kykObPNtqcg+F+8wBDzvWcauwDLHa7Yo=";
          };

          nativeBuildInputs = [
            rustPlatform.cargoSetupHook
            rustPlatform.maturinBuildHook
            cargo
            rustc
          ];

          buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
            libiconv
          ];

          nativeCheckInputs = [
            pytestCheckHook
          ];

          pythonImportsCheck = [
            "rpds"
          ];

          meta = with lib; {
            description = "Python bindings to Rust's persistent data structures (rpds";
            homepage = "https://pypi.org/project/rpds-py/";
            license = licenses.mit;
            maintainers = with maintainers; [ fab ];
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
