{ config, lib, pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    defaultCacheTtl = 86400;
    pinentryFlavor = "curses";
  };
}
