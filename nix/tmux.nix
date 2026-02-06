{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;

    shell = "${pkgs.nushell}/bin/nu";

    baseIndex = 1;           # Start window numbering at 1 instead of 0
    escapeTime = 0;          # Fix annoying delay when pressing Esc in Vim
    keyMode = "vi";          # Vi keybindings in copy mode
    mouse = true;            # Enable mouse (clickable windows, resizable panes)
    historyLimit = 1000000;  # increase history size (from 2,000)

    # Nix manages tmux plugins automatically (no need for tpm)
    plugins = with pkgs.tmuxPlugins; [
      sensible               # Sensible defaults (fix terminal colors, etc.)
      yank                   # Copy to system clipboard seamlessly
      pain-control           # Better pane management (vim style: h,j,k,l)

      vim-tmux-navigator     # The bridge to Noevim

      {
        plugin = tmux-fzf;
        extraConfig = ''
          TMUX_FZF_OPTIONS="-p -w 100% -h 100% -m"
        '';
      }

      # Tokyo Night Theme
      {
        plugin = tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_netspeed_showip 1  # Display IPv4 address
        '';
      }

    ];

    # For settings not directly supported by Home Manager abstraction
    extraConfig = ''
      # True color support (ensure your terminal supports this)
      set-option -sa terminal-overrides ",xterm*:Tc"

      set-option -g status-position top
      set-option -g renumber-windows on

      bind Space choose-tree
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"

      # Easy config reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'

      bind k copy-mode
      bind-key -T copy-mode-vi M-k send-keys -X halfpage-up
      bind-key -T copy-mode-vi M-j send-keys -X halfpage-down
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle 
      bind-key -T copy-mode-vi i send-keys -X cancel

      bind f switch-client -T fzf-tab
      bind -T fzf-tab f run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/main.sh"
      bind -T fzf-tab k run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/keybinding.sh"
      bind -T fzf-tab s run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
      bind -T fzf-tab w run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/window.sh switch"
      bind -T fzf-tab p run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/pane.sh switch"
      bind -T fzf-tab c run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/command.sh"

      set -g status off
      set-hook -g session-created 'if -F "#{==:#{session_windows},1}" "set status off" "set status on"'
      set-hook -g window-linked   'if -F "#{==:#{session_windows},1}" "set status off" "set status on"'
      set-hook -g window-unlinked 'if -F "#{==:#{session_windows},1}" "set status off" "set status on"'
    '';
  };

}
