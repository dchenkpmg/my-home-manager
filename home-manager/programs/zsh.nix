{ config, lib, pkgs, ... }:
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
                  /usr/bin/dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &
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
