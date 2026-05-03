{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.direnv = {
    enable = false;
    enableZshIntegration = true;
    package = pkgs-unstable.direnv;
  };
  home.file.".config/direnv/direnv.toml".text = ''
    [global]
    load_dotenv = true
  '';
}
