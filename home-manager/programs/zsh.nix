{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs.zsh = {
    enable = true;
    initExtraBeforeCompInit = ''
      # Ensure Nix profile is in PATH early
      export PATH="$HOME/.nix-profile/bin:$PATH"
    '';
    autosuggestion.enable = true;
    initExtraFirst = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
      # for mac
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
       . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      fpath=(${pkgs.docker}/zsh/vendor-completions $fpath)
      source ~/.p10k.zsh

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


      function awsauth {
        ~/seek/aws-auth-bash/auth.sh "$@";
        script_result="$?"

        [[ -r "$HOME/.aws/sessiontoken" ]] && . "$HOME/.aws/sessiontoken";

        return "$script_result"
      }
    '';
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
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
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
    oh-my-zsh = {
      enable = true;
      package = pkgs-unstable.oh-my-zsh;
      # Specify the plugins you want to use
      plugins = [
        "git"
        "direnv"
        "docker"
        "docker-compose"
        "poetry"
        "tmux"
      ];
    };
  };
}
