{ config, lib, pkgs, ... }:
let
  username = "dylanchen1";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home = {
    inherit username;
    packages = with pkgs; [
      home-manager
      zsh
      eza
      python3
      git
      yazi
      tmux
      docker
      bat
      btop
      gnupg
      du-dust
      gping
      zathura
      azure-cli
      azure-functions-core-tools
      texliveFull
      curl
      fd
      git
      git-lfs
      gnugrep 
      graphviz
      gum
      gzip
      imagemagick
      lsof
      man
      nodejs
      ripgrep
      rsync
      sqlite
      tree
      time
      tlrc
      libtelnet
      wget
      unzip
    ];

    homeDirectory = "/home/${username}";

    stateVersion = "23.11";
    file.".bash_sysinit".source = link "/home/${username}/my-home-manager/.bash_sysinit";
    # file.".tmux.conf".source = link "/home/${username}/my-home-manager/.tmux.conf";
    # file.".tmux.conf.local".source = link "/home/${username}/my-home-manager/.tmux.conf.local";
    
  };

  # programs.tmux = {
  #   enable = true;
  # };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable Zsh
  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
      fpath=(${pkgs.docker}/zsh/vendor-completions $fpath)
      source ~/.p10k.zsh
      
      function yy() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      function com() {
        nvim /tmp/commit_msg.txt

        # Check the message with global commitlint
        commitlint --config ~/commitlint.config.js < /tmp/commit_msg.txt

        if [  $? -ne 0  ]; then
          echo "Commitlint check failed"
          return 1
        fi

        # Use a file for the commit message to handle multiline entries
        git commit -F /tmp/commit_msg.txt
        
        rm /tmp/commit_msg.txt
        return 0
      }

      function gumc() {
        local TYPE SCOPE SUMMARY DESCRIPTION

        # Use gum to choose the type of change
        TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
        
        # Use gum to input the scope
        SCOPE=$(gum input --placeholder "scope")

        # Since the scope is optional, wrap it in parentheses if it has a value
        test -n "$SCOPE" && SCOPE="($SCOPE)"

        # Pre-populate the input with the type(scope): so that the user may change it
        SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
        
        # Use gum to write the description
        DESCRIPTION=$(gum write --placeholder "Details of this change (CTRL+D to finish)")

        # Commit these changes
        gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
      }

      # Preferred editor for local and remote sessions
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
      else
        export EDITOR='nvim'
      fi


      if [ -f ~/.bash_sysinit ]; then
          . ~/.bash_sysinit
      fi
    '';
    sessionVariables = {
      GPG_TTY = "''$TTY";

      PATH="''$PATH:''$HOME/.pulumi/bin:''$PATH:''$HOME/.local/bin:''$PATH:''$HOME/.pyenv/bin";

      OPENAI_API_TYPE = "azure";
      OPENAI_API_BASE = "https://dchenkpmg-openai.openai.azure.com";
      OPENAI_API_AZURE_ENGINE = "dchenkpmg";
      OPENAI_API_AZURE_VERSION = "2024-02-01";
      OPENAI_API_KEY = "***REMOVED***";

      AZURE_API_BASE = "https://dchenkpmg-openai.openai.azure.com/";
      AZURE_API_KEY = "***REMOVED***";
      AZURE_API_VERSION = "2024-02-01";
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {

      # Set personal aliases, overriding those provided by oh-my-zsh libs,
      # plugins, and themes. Aliases can be placed here, though oh-my-zsh
      # users are encouraged to define aliases within the ZSH_CUSTOM folder.
      # For a full list of active aliases, run `alias`.
      #
      # Example aliases
      # alias zshconfig="mate ~/.zshrc"
      # alias ohmyzsh="mate ~/.oh-my-zsh"
      bfg = "java -jar ~/bfg-1.14.0.jar";
      # https://forum.endeavouros.com/t/exa-has-been-deprecated/45293/12
      # ls to eza
      ls = "eza --color=always --group-directories-first --icons"; # ls
      ll = "eza -la --icons --octal-permissions --group-directories-first";
      l = "eza -albGF --header --git --color=always --group-directories-first --icons"; # long list
      llm = "eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons"; # long list, modified date sort
      la = "eza --long --all --group --group-directories-first";
      lx = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons"; # all + extended list

      # # ls to eza - modalità speciali
      lS = "eza -1 --color=always --group-directories-first --icons"; # one column, just names
      lt = "eza --tree --level=2 --color=always --group-directories-first --icons"; # tree
      "l." = "eza -a | grep -E '''^\\.'''";

      # # alias gumc="sudo ~/commit.sh"
      cd = "z";
      interpreter = "interpreter --model azure/dchenkpmg --context_window=128000 --max_output=10000";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    oh-my-zsh = {
      enable = true;
      # Specify the plugins you want to use
      plugins = [
        "git"
        "z"
        "docker"
        "docker-compose"
      ];
    };
  };
}
