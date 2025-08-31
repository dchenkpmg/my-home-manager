{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        syntax-theme = "rose-pine";
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
    };
    aliases = {
      graph = "log --all --graph --decorate --oneline";
    };
    ignores = [
      ".DS_Store"
    ];
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
