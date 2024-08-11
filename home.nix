{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
      cowsay
      lolcat
    ];

    username = "dylanchen1";
    homeDirectory = "/home/dylanchen1";

    stateVersion = "23.11";
  };
}
