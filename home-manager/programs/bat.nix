{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.bat = {
    enable = true;
    package = pkgs-unstable.bat;
    config = {
      theme = "rose-pine";
    };
    themes = {
      rose-pine = {
        src = pkgs.fetchFromGitHub {
          owner = "rose-pine";
          repo = "tm-theme";
          rev = "6d556734541ccb04172e81fd58de4a35fff72d19";
          sha256 = "sha256-5+fG21KbB7bdPvszkz9Ftl6fCDGs17fJNTAXFRFWZGo=";
        };
        file = "dist/rose-pine.tmTheme";
      };
    };
  };
}
