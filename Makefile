update:
	nix flake update --update-input nixpkgs
tests:
	sudo nixos-container destroy funkwhale
	sudo nixos-container create funkwhale --flake ./test/
	sudo nixos-container start funkwhale
	# sudo nixos-container root-login funkwhale
