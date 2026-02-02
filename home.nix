{ config, pkgs, host, ... }:
let
  link = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/${path}";
in
{
  imports = [
    ./nix/nixvim.nix
    # ./nix/nvf.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.username = "sirex";
  home.homeDirectory = "/home/sirex";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    nh
    fd
    ripgrep
    matugen
    manix
  ];

  programs.zsh = {
    enable = true;
    localVariables = {
      HIST_STAMPS = "mm/dd/yyyy"; 
    };
    shellAliases = {
      lg = "lazygit";
      ld = "lazydocker";
      hms = "home-manager switch --flake ~/dotfiles#${host}";
    };
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/zsh";
      theme = "sirex";
    };
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      lg = "lazygit";
      ld = "lazydocker";
      hms = "home-manager switch --flake ~/dotfiles#${host}";
    };
    plugins = with pkgs.nushellPlugins; [
      polars
    ];
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      format = builtins.concatStringsSep "" [
        "$cmd_duration"
        "$status"
        "$time"
        "$username"
        "$hostname"
        "$directory"
        "$all"
      ];
      add_newline = true;
      cmd_duration = {
        min_time = 3000; # seconds
        format = "(took [$duration]($style))\n";
      };
      status = {
        disabled = false;
        symbol = "✘ ";
        style = "bold red";
        format = "[$symbol$int $common_meaning$signal_name]($style)\n";
        map_symbol = true; # Use the symbol ✘
        pipestatus = true; # Show status for all commands in a pipeline
      };
      time = {
        disabled = false;
        time_format = "%R"; # HH:MM format
        style = "bold blue";
        format = "\n## [$time]($style): ";
      };
      username = {
        show_always = true;
        style_user = "blue";
        format = "[$user]($style)";
      };
      hostname = {
        ssh_only = false; # Always show hostname as requested
        style = "magenta";
        format = "@[$hostname]($style):";
      };

      directory.style = "bold blue";

      character = {
        # Normal User Symbol
        success_symbol = "[\\$](bold blue)";
        error_symbol = "[\\$](bold blue)";

        # Root User Symbol
        vicmd_symbol = "[#](bold red)"; 
      };

      python.symbol = " "; 
      nix_shell.symbol = " ";
      package.symbol = "󰏗 ";
      docker_context.symbol = " ";

      palette = "tokyonight";

      palettes = {
        tokyonight = {
          # Base Backgrounds
          bg_dark = "#1a1b26";
          bg = "#24283b";

          # Foreground / Text
          fg = "#c0caf5";
          fg_dark = "#a9b1d6";

          # Core Colors
          black = "#414868";   # Terminal Black
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";   # Terminal White

          # Accents
          orange = "#ff9e64";
          teal = "#73daca";
          blue_gray = "#565f89"; # Comments/Non-focus
        };
      };
    };
  };

  programs.tmux = {
    enable = true;

    baseIndex = 1;           # Start window numbering at 1 instead of 0
    escapeTime = 0;          # Fix annoying delay when pressing Esc in Vim
    keyMode = "vi";          # Vi keybindings in copy mode
    mouse = true;            # Enable mouse (clickable windows, resizable panes)
    historyLimit = 1000000;  # increase history size (from 2,000)

    # 2. Plugins
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

    # 3. Extra Configuration
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

      bind k copy-mode
      bind-key -T copy-mode-vi M-k send-keys -X halfpage-up
      bind-key -T copy-mode-vi M-j send-keys -X halfpage-down
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi 'C-v' send-keys -X rectangle-toggle 

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

  programs.eza = {
    enable = true;
    icons = "auto";
    extraOptions = [
      "--long"
      "--header"
      "--mounts"
      "--smart-group"
      "--time-style=long-iso"
    ];
    enableZshIntegration = true;
  };

  programs.bat.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Mantas";
      user.email = "sirexas@gmail.com";
    };
  };

  programs.lazygit.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  home.file = {
    ".config/zsh/themes/sirex.zsh-theme".source = ./zsh/themes/sirex.zsh-theme;
  };

  xdg.configFile = {
    "DankMaterialShell".source = link "dms";
    "kitty".source = link "kitty";
    "niri".source = link "niri";
    "yazi".source = link "yazi";
    "kanshi".source = link "kanshi";
    "lazygit".source = link "lazygit";
  };
}
