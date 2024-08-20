.PHONY: switch
switch:
	home-manager switch --flake .#dylanchen1

.PHONY: clean
clean:
	nix-collect-garbage -d

