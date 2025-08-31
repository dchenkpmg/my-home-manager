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
          rev = "c4cab0c431f55a3c4f9897407b7bdad363bbb862";
          sha256 = "sha256-maQp4QTJOlK24eid7mUsoS7kc8P0gerKcbvNaxO8Mic=";
        };
        file = "dist/themes/rose-pine.tmTheme";
      };
    };
  };
}
