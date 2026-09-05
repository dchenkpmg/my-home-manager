{ pkgs-unstable, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs-unstable.direnv;
  };
  home.file.".config/direnv/direnv.toml".text = ''
    [global]
    load_dotenv = true
  '';
}
