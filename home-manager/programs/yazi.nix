{ config, lib, pkgs, pkgs-unstable, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs-unstable.yazi;
    settings = {
      opener = {
        open = [{
          run = "wsl-open \"$@\"";
        }];
      };
    };
  };
}
