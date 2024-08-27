{ config, lib, pkgs, pkgs-unstable, ... }:
{
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

      # Define Rose Pine colors
      # ROSE_PINE_BASE="#191724"
      # ROSE_PINE_SURFACE="#1f1d2e"
      # ROSE_PINE_OVERLAY="#26233a"
      # ROSE_PINE_MUTED="#6e6a86"
      # ROSE_PINE_SUBTLE="#908caa"
      # ROSE_PINE_TEXT="#e0def4"
      # ROSE_PINE_LOVE="#eb6f92"
      # ROSE_PINE_GOLD="#f6c177"
      # ROSE_PINE_ROSE="#ebbcba"
      # ROSE_PINE_PINE="#31748f"
      # ROSE_PINE_FOAM="#9ccfd8"
      # ROSE_PINE_IRIS="#c4a7e7"
      # ROSE_PINE_HIGHLIGHT_LOW="#21202e"
      # ROSE_PINE_HIGHLIGHT_MED="#403d52"
      # ROSE_PINE_HIGHLIGHT_HIGH="#524f67"


      function gumc() {
        local TYPE SCOPE SUMMARY DESCRIPTION

        # Use gum to choose the type of change
        TYPE=$(gum choose --cursor.foreground "#c4a7e7" --header.foreground "#c4a7e7" --selected.foreground "#f6c177" "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
      
        # Use gum to input the scope
        # SCOPE=$(gum input --placeholder "scope")

        SCOPE=$(gum input \
            --placeholder "scope" \
            --cursor.foreground "#c4a7e7" \
        )

        # Since the scope is optional, wrap it in parentheses if it has a value
        test -n "$SCOPE" && SCOPE="($SCOPE)"

        # Pre-populate the input with the type(scope): so that the user may change it
        SUMMARY=$(gum input --cursor.foreground "#c4a7e7" --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
        
        # Use gum to write the description
        DESCRIPTION=$(gum write --cursor.foreground "#c4a7e7" --placeholder "Details of this change (ENTER to finish)")

        # Commit these changes
        gum confirm \
          --prompt.foreground="#e0def4" \
          --selected.foreground="#1f1d2e" \
          --selected.background="#f6c177" \
          --unselected.foreground="#6e6a86" \
          --unselected.background="#1f1d2e" \
          "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION"
      }

      # Preferred editor for local and remote sessions
      if [[ -n $SSH_CONNECTION ]]; then
        export EDITOR='vim'
      else
        export EDITOR='nvim'
      fi

      # Function to auto-pass sudo password (optional)
      sudo_autopasswd() {
          # Uncomment and set your password if you want to auto-pass sudo
          # echo "<your_ubuntu_wsl2_password>" | sudo -Svp ""
          :
      }

      # Function to reset sudo password cache
      sudo_resetpasswd() {
          sudo -k
      }

      # Check if running inside WSL2
      if [ -n "$WSL_DISTRO_NAME" ]; then
          # Set up D-Bus and user runtime directory
          export XDG_RUNTIME_DIR=/run/user/$(id -u)
          if [ ! -d "$XDG_RUNTIME_DIR" ]; then
              sudo_autopasswd
              sudo mkdir -p $XDG_RUNTIME_DIR && sudo chmod 700 $XDG_RUNTIME_DIR && sudo chown $(id -un):$(id -gn) $XDG_RUNTIME_DIR
              sudo service dbus start
              sudo_resetpasswd
          fi

          # Function to set up session D-Bus
          set_session_dbus() {
              local bus_file_path="$XDG_RUNTIME_DIR/bus"
              export DBUS_SESSION_BUS_ADDRESS=unix:path=$bus_file_path
              if [ ! -e "$bus_file_path" ]; then
                  (/usr/bin/dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &)
              fi
          }

          # Call the function to set up session D-Bus
          set_session_dbus
      fi
    '';
    sessionVariables = {
      GPG_TTY = "$TTY";

      PATH = "$PATH:$HOME/.pulumi/bin:$PATH:$HOME/.local/bin:$PATH:$HOME/.pyenv/bin";

      OPENAI_API_TYPE = "azure";
      OPENAI_API_BASE = "https://dchenkpmg-openai.openai.azure.com";
      OPENAI_API_AZURE_ENGINE = "dchenkpmg";
      OPENAI_API_AZURE_VERSION = "2024-02-01";

      AZURE_API_BASE = "https://dchenkpmg-openai.openai.azure.com/";
      AZURE_API_VERSION = "2024-02-01";
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    shellAliases = {

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
      package = pkgs-unstable.oh-my-zsh;
      # Specify the plugins you want to use
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "poetry"
        "tmux"
      ];
    };
  };
}
