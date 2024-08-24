{ config, lib, pkgs, pkgs-unstable, ... }:
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
      git-lfs
      gnugrep
      graphviz
      gum
      gzip
      imagemagick
      jq
      lsof
      man
      pkgs-unstable.neovim
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
      cargo
      tree-sitter
      neofetch
    ];

    homeDirectory = "/home/${username}";

    stateVersion = "23.11";

    file.".tmux/plugins/tpm".source = link "/home/${username}/my-home-manager/tpm";
    file.".config/nvim".source = link "/home/${username}/my-home-manager/nvim";
    file.".p10k.zsh".source = link "/home/${username}/my-home-manager/.p10k.zsh";
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    extraConfig = ''
      setw -g xterm-keys on
      set -s escape-time 10                     # faster command sequences
      set -sg repeat-time 600                   # increase repeat timeout
      set -s focus-events on

      set -q -g status-utf8 on                  # expect UTF-8 (tmux < 2.2)
      setw -q -g utf8 on

      set -g history-limit 5000                 # boost history

      # bind r run '"$TMUX_PROGRAM" ''${TMUX_SOCKET:+-S "$TMUX_SOCKET"} source "$TMUX_CONF"' \; display "#{TMUX_CONF} sourced"

      set -g base-index 1           # start windows numbering at 1
      setw -g pane-base-index 1     # make pane numbering consistent with windows

      setw -g automatic-rename on   # rename window to reflect current program
      set -g renumber-windows on    # renumber windows when a window is closed

      set -g set-titles on          # set terminal title
      set -g set-titles-string "🌐 #h 📂 #S 🔢 #I 📝 #W"

      set -g display-panes-time 800 # slightly longer pane indicators display time
      set -g display-time 1000      # slightly longer status messages display time

      set -g status-interval 10     # redraw status line every 10 seconds

      bind -n C-l send-keys C-l \; run 'sleep 0.2' \; clear-history

      set -g monitor-activity on
      set -g visual-activity off
      bind C-c new-session

      # find session
      bind C-f command-prompt -p find-session 'switch-client -t %%'

      # session navigation
      bind BTab switch-client -l  # move to last session

      # split current window horizontally
      bind - split-window -v
      # split current window vertically
      bind _ split-window -h

      # pane navigation
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # maximize current pane
      bind + run "cut -c3- '#{TMUX_CONF}' | sh -s _maximize_pane '#{session_name}' '#D'"

      # pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # window navigation
      unbind n
      unbind p
      bind -r C-h previous-window # select previous window
      bind -r C-l next-window     # select next window
      bind Tab last-window        # move to last active window

      # toggle mouse
      bind m run "cut -c3- '#{TMUX_CONF}' | sh -s _toggle_mouse"

      bind U run "cut -c3- '#{TMUX_CONF}' | sh -s _urlview '#{pane_id}'"

      bind F run "cut -c3- '#{TMUX_CONF}' | sh -s _fpp '#{pane_id}' '#{pane_current_path}'"

      bind Enter copy-mode # enter copy mode

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel
      bind -T copy-mode-vi H send -X start-of-line
      bind -T copy-mode-vi L send -X end-of-line

      if -b 'command -v xsel > /dev/null 2>&1' 'bind y run -b "\"\''$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - | xsel -i -b"'
      if -b '! command -v xsel > /dev/null 2>&1 && command -v xclip > /dev/null 2>&1' 'bind y run -b "\"\''$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - | xclip -i -selection clipboard >/dev/null 2>&1"'
      # copy to Wayland clipboard
      if -b 'command -v wl-copy > /dev/null 2>&1' 'bind y run -b "\"\''$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - | wl-copy"'
      # copy to macOS clipboard
      if -b 'command -v pbcopy > /dev/null 2>&1' 'bind y run -b "\"\''$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - | pbcopy"'
      if -b 'command -v reattach-to-user-namespace > /dev/null 2>&1' 'bind y run -b "\"\''$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - | reattach-to-usernamespace pbcopy"'
      # copy to Windows clipboard
      if -b 'command -v clip.exe > /dev/null 2>&1' 'bind y run -b "\"''\$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - | clip.exe"'
      if -b '[ -c /dev/clipboard ]' 'bind y run -b "\"\''$TMUX_PROGRAM\" \''${TMUX_SOCKET:+-S \"\''$TMUX_SOCKET\"} save-buffer - > /dev/clipboard"'


      bind b list-buffers     # list paste buffers
      bind p paste-buffer -p  # paste from the top paste buffer
      bind P choose-buffer    # choose which buffer to paste from


      set -g mouse on

      set -g status-keys vi
      set -g mode-keys vi


      set -g default-terminal "tmux-256color"
      set-option -a terminal-features ',xterm-256color:RGB'

      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0

      if-shell 'test -n "$WSL_DISTRO_NAME"' {
        set -as terminal-overrides ',*:Setulc=\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m' # underscore colours - needs tmux-3.0 (wsl2 in Windows Terminal)
      }

      %if #{==:#{TMUX_PROGRAM},}
        run 'TMUX_PROGRAM="''$(LSOF=''$(PATH="''$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" command -v lsof); ''$LSOF -b -w -a -d txt -p #{pid} -Fn 2>/dev/null | perl -n -e "if (s/^n((?:.(?!dylib$|so$))+)$/\1/g && s/(?:\s+\([^\s]+?\))?$//g) { print; exit } } exit 1; {" || readlink "/proc/#{pid}/exe" 2>/dev/null || printf tmux)"; "''$TMUX_PROGRAM" -S #{socket_path} set-environment -g TMUX_PROGRAM "''$TMUX_PROGRAM"'
      %endif

      %if #{==:#{TMUX_SOCKET},}
        run '"''$TMUX_PROGRAM" -S #{socket_path} set-environment -g TMUX_SOCKET "#{socket_path}"'
      %endif

      %if #{==:#{TMUX_CONF},}
        run '"''$TMUX_PROGRAM" set-environment -g TMUX_CONF ''$(for conf in "''$HOME/.tmux.conf" "''$XDG_CONFIG_HOME/tmux/tmux.conf" "''$HOME/.config/tmux/tmux.conf"; do [ -f "''$conf" ] && printf "%s" "''$conf" && break; done)'
      %endif


      # Bind keys to split windows while retaining the current path
      bind-key % split-window -h -c "#{pane_current_path}"
      bind-key '"' split-window -v -c "#{pane_current_path}"

      set -g @plugin 'rose-pine/tmux'
      set -g @rose_pine_variant 'main' # Options are 'main', 'moon' or 'dawn'
      set -g @rose_pine_host 'on' # Enables hostname in the status bar
      set -g @rose_pine_directory 'on' # Turn on the current folder component in the status bar
      set -g @rose_pine_date_time '%d/%m/%y %H:%M' # It accepts the date UNIX command format (man date for info)
      set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
      set -g @rose_pine_bar_bg_disable 'on'
      set -g @rose_pine_bar_bg_disabled_color_option 'default'
      set -g @rose_pine_show_current_program 'on' # Forces tmux to show the current running program as window name
      set -g @rose_pine_show_pane_directory 'on' # Forces tmux to show the current directory as
      set -g @rose_pine_field_separator ' | ' # Again, 1-space padding, it updates with prefix + I
      set -g @plugin 'tmux-plugins/tpm'
      
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
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
      AZURE_OPENAI_API_KEY = "";
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
