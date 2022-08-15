
# Dev notes : how to upgrade

## Update funkwhale nixos pkgs

### Module

See changes in https://docs.funkwhale.audio/changelog.html (look for manual actions...)

Funkwhale code is at https://dev.funkwhale.audio/funkwhale/funkwhale
Look at theses files and make changes in _module.nix_ :
- deploy/*.service
- deploy/nginx.template

Edit module in `nixos/modules/services/web-apps/funkwhale/`

### Package

Look for requirements changes ( ex : `git diff 1.0.1 1.2.7 -- api/requirements/base.txt`)
* system packages in api/requirements.apt
* python packages in api/requirements/base.txt (add missing requirements, then change versions by testing)


Edit flake.nix

* update release version
* update sha256 checksums

### Test

```sh
make local
make root
```

In the container :

```sh
systemctl status

```
