
# Dev notes : how to upgrade

## Update funkwhale nixos pkgs

Get last Funkwhale release source code in order to compare with previous release.

```sh
./fetchFunkwhaleCode.sh 1.3.1
```

### Module

See changes in https://docs.funkwhale.audio/changelog.html (look for manual actions...)

Compare releases `meld funkwhale_upstream_1.2.9/deploy/ funkwhale_upstream_1.3.1/deploy/`

Look at theses files and make changes in _module.nix_ :
- deploy/*.service
- deploy/nginx.template

Edit module in `nixos/modules/services/web-apps/funkwhale/`

### Package

Look for requirements changes
* system packages in api/requirements.apt
* python packages  : checkout the _develop_ branch and look at the api/poetry.lock file at the commit just after the merge of release tag  

```sh
./fetchFunkwhaleCode.sh 1.3.1

grep "name\|^version =" funkwhale_upstream_1.3.1/api/poetry.lock > docs/pythonDeps_1.3.1.txt
diff docs/pythonDeps_1.2.9.txt docs/pythonDeps_1.3.1.txt
```


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
