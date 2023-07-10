update:
	nix flake lock --update-input nixpkgs
local:
	cd container && nix flake lock --update-input funkwhale --update-input typesense && cd -
	sudo nixos-container destroy funkwhale
	sudo nixos-container create funkwhale --flake ./container/
	sudo nixos-container start funkwhale
root:
	sudo nixos-container root-login funkwhale
superuser:
	sudo nixos-container run funkwhale -- sudo --user=funkwhale sh -c 'cd /srv/funkwhale && ./createSuperUser.sh'
