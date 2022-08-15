update:
	nix flake lock nixpkgs
local:
	cd container && nix flake lock --update-input funkwhale && cd -
	sudo nixos-container destroy funkwhale
	sudo nixos-container create funkwhale --flake ./container/
	sudo nixos-container start funkwhale
root:
	sudo nixos-container root-login funkwhale
