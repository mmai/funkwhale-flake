# Funkwhale flake

Below is an example of a nixos configuration using this flake :

```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
  inputs.funkwhale.url = "github:mmai/funkwhale-flake";

  outputs = { self, nixpkgs, funkwhale }: 
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {

      server-hostname = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [ 
          nixpkgs.nixosModules.notDetected
	        funkwhale.nixosModule
          ( { config, pkgs, ... }:
            { imports = [ ./hardware-configuration.nix ];

              nix = {
                package = pkgs.nixUnstable;
                extraOptions = ''
                  experimental-features = nix-command flakes
                '';
              };

              nixpkgs.overlays = [ overlay-unstable funkwhale.overlay ];

              services.funkwhale = {
                enable = true;
                hostname = "funkwhale.rhumbs.fr";
                defaultFromEmail = "noreply@funkwhale.rhumbs.fr";
                protocol = "http"; # Disable https for local tests
                api = {
                  # Generate one using `openssl rand -base64 45`, for example
                  djangoSecretKey = "i1vh21SWu1CayM5KJILxn4aE1jEhvbF9XSxsT8chovgJll1v54VsH0X3AGsJ";
                };
              };

              security.acme = {
                email = "your@email.com";
                acceptTerms = true;
              };

              # Overrides default 30M
              services.nginx.clientMaxBodySize = "100m";

              services.fail2ban.enable = true;
              networking.firewall.allowedTCPPorts = [ 80 443 ];
            })
        ];
      };

    };
  };
}
```

The front files doesn't build (pull requests are welcomed), so you need to compile them on your local system and copy them to _/srv/funkwhale/front/dist_ on your funkwhale server:

```
wget https://dev.funkwhale.audio/funkwhale/funkwhale/-/archive/1.0/funkwhale-1.0.zip
unzip funkwhale-1.0.zip
cd funkwhale-1.0/front
yarn
yarn build
rsync -azv dist/ me@myfunkwhaleserver:/srv/funkwhale/front/dist/
```

