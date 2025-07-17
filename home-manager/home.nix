{ config, lib, pkgs, pkgs-unstable, ... }:
let
  username = "dylanchen1";
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
    ./services/gpg-agent.nix
  ];
in
{
  imports = modules;
  home = {
    inherit username;
    packages = with pkgs; [
      home-manager
      zsh
      gcc
      eza
      docker
      bat
      gnupg
      du-dust
      gping
      pkgs-unstable.azure-cli
      pkgs-unstable.azure-functions-core-tools
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
      libtelnet
      wget
      unzip
      pkgs-unstable.cargo
      tree-sitter
      neofetch
      pkgs-unstable.lazygit
      at-spi2-core
      fontconfig
      wsl-open
      pkgs-unstable.ttyper
      pkgs-unstable.go
      shellcheck
      pkgs-unstable.uv
      pkgs-unstable.typescript
      pkgs-unstable.bfg-repo-cleaner
      pkgs-unstable.gh
      pkgs-unstable.yarn
      pkgs-unstable.duckdb
      pkgs-unstable.wslu
      pkgs-unstable.coursier
      pkgs-unstable.lsix
      pkgs-unstable.yazi
    ];

    homeDirectory = "/home/${username}";

    stateVersion = "23.11";

    file.".config/nvim".source = link "/home/${username}/my-home-manager/nvim";
    file.".p10k.zsh".source = link "/home/${username}/my-home-manager/terminal/.p10k.zsh";
    file.".markdownlint-cli2.yaml".text = ''
      config:
        MD013: false
    '';
  };
}
