{
  services.gpg-agent = {
    enable = false;
    enableZshIntegration = true;
    defaultCacheTtl = 86400;
    maxCacheTtl = 86400;
    pinentry = {
      package = "curses";
    };
  };
}
