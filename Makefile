.PHONY: switch update clean

switch:
	home-manager switch --flake .#dylanchen1

update:
	nix flake update

clean:
	nix-collect-garbage -d

