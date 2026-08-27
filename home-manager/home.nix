{
  config,
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
      (pkgs.writeShellScriptBin "show-tmux-popup" ''
        #!/bin/bash
        session="$(tmux display -p '_popup_#S')"
        if ! tmux has -t "$session" 2>/dev/null; then
          parent_session="$(tmux display -p '#{session_id}')"
          session_id="$(tmux new-session -c '#{pane_current_path}' -dP -s "$session" -F '#{session_id}' -e TMUX_PARENT_SESSION="$parent_session")"
          exec tmux set-option -t "$session_id" key-table popup \; \
            set-option -t "$session_id" status off \; \
            set-option -t "$session_id" prefix None \; \
            attach -t "$session"
        fi
        exec tmux attach -t "$session" >/dev/null
      '')
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
      pkgs-unstable.poetry
      pkgs-unstable.statix
      pkgs-unstable.google-cloud-sdk
      pkgs-unstable.ffmpeg
      pkgs-unstable.pnpm
      pkgs-unstable.pulumi
      pkgs-unstable.pulumiPackages.pulumi-nodejs
    ];

    homeDirectory = "/Users/${username}";

    stateVersion = "25.05";
    file = {
      ".config/nvim".source = link "/Users/${username}/my-home-manager/nvim";
      ".p10k.zsh".source = link "/Users/${username}/my-home-manager/terminal/.p10k.zsh";
      ".markdownlint-cli2.yaml".text = ''
        config:
          MD013: false
      '';
    };
  };
}
