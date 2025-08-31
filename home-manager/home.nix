{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  username = "dychen";
  link = config.lib.file.mkOutOfStoreSymlink;
  modules = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/zoxide.nix
    ./programs/git.nix
    ./programs/zathura.nix
    ./programs/btop.nix
    ./programs/fzf.nix
    ./programs/direnv.nix
    ./programs/bat.nix
    ./programs/yazi.nix
    ./services/gpg-agent.nix
  ];
in {
  imports = modules;
  home = {
    inherit username;
    packages = with pkgs; [
      home-manager
      eza
      docker
      gnupg
      du-dust
      gping
      texliveFull
      curl
      fd
      git-lfs
      gnugrep
      graphviz
      pkgs-unstable.gum
      gzip
      imagemagick
      jq
      lsof
      man
      pkgs-unstable.neovim
      pkgs-unstable.nodejs
      ripgrep
      rsync
      sqlite
      tree
      time
      tlrc
      wget
      unzip
      pkgs-unstable.cargo
      tree-sitter
      neofetch
      pkgs-unstable.lazygit
      pkgs-unstable.ttyper
      pkgs-unstable.go
      shellcheck
      pkgs-unstable.uv
      pkgs-unstable.typescript
      pkgs-unstable.gh
      pkgs-unstable.yarn
      pkgs-unstable.duckdb
      pkgs-unstable.coursier
      pkgs-unstable.lsix
      pkgs-unstable.circumflex
    ];

    homeDirectory = "/Users/${username}";

    stateVersion = "25.05";

    file.".config/nvim".source = link "/Users/${username}/my-home-manager/nvim";
    file.".p10k.zsh".source = link "/Users/${username}/my-home-manager/terminal/.p10k.zsh";
    file.".markdownlint-cli2.yaml".text = ''
      config:
        MD013: false
    '';
  };
}
