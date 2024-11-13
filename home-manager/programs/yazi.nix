{ config, lib, pkgs, pkgs-unstable, ... }:
{
  programs.yazi = {
    enable = false;
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
