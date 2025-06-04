{ config, lib, pkgs, pkgs-unstable, ... }:
{
  programs.gh = {
    enable = true;
    package = pkgs-unstable.gh;
  };
}
