.PHONY: switch install update clean

switch:
	home-manager switch --flake .#dylanchen1

install:
	nix --extra-experimental-features 'nix-command flakes' \
		run home-manager/release-25.05 -- switch -b backup --flake .#dylanchen1
	exec zsh -l

update:
	nix flake update

clean:
	nix-collect-garbage -d

