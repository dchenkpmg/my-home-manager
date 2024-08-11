{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
    ];

    username = "dylanchen1";
    homeDirectory = "/home/dylanchen1";

    stateVersion = "23.11";
  };
}
