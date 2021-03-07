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

              nixpkgs.overlays = [ funkwhale.overlay ];

              services.funkwhale = {
                enable = true;
                hostname = "funkwhale.rhumbs.fr";
                defaultFromEmail = "noreply@funkwhale.rhumbs.fr";
                protocol = "https";
                # forceSSL = false; # uncomment when LetsEncrypt needs to access "http:" in order to check domain
                api = {
                  # Generate one using `openssl rand -base64 45`, for example
                  djangoSecretKey = "yoursecretkey";
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

## Imports

* Copy audio files to the server on the _/srv/funkwhale/music/import/_ directory
* execute the import script as _funkwhale_ user, with the library id as a parameter
```
su -l funkwhale -s /bin/sh -c "/srv/funkwhale/importMusic.sh <your_library_id>"
```

## Test on a local container

Start the funkwhale services in a container on the local machine :

```sh
make test
```

Create the super user :

```sh
sudo nixos-container run funkwhale -- sudo --user=funkwhale sh -c 'cd /srv/funkwhale && ./createSuperUser.sh'
```

Connect to the local service:

```sh
firefox http://funkwhale
```
