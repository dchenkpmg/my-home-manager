{ config, lib, pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
  };
}
