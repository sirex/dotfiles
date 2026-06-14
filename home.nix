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
    ./nix/starship.nix
    ./nix/tmux.nix
    ./nix/beancount.nix
  ];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  home.username = "sirex";
  home.homeDirectory = "/home/sirex";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    nh         # Nix help
    manix      # Nix help
    fd         # File searching
    ripgrep    # Text searching
    jq         # JSON Query
    matugen
    poppler    # PDF previews
    ffmpegthumbnailer # Video thumbnais
    p7zip      # Archive extraction (yazi built-in extract plugin)
    gh         # GitHub CLI
    git-annex  # For backups
  ];

  programs.zsh = {
    enable = true;
    localVariables = {
      HIST_STAMPS = "mm/dd/yyyy"; 
    };
    shellAliases = {
      vi = "nvim";
      lg = "lazygit";
      ld = "lazydocker";
      hms = "home-manager switch --flake ~/dotfiles#${host}";
    };
    oh-my-zsh = {
      enable = true;
      custom = "${config.home.homeDirectory}/.config/zsh";
      theme = "sirex";
    };
    envExtra = ''
      if [ -f "$HOME/.env" ]; then
        export $(grep -v '^#' "$HOME/.env" | xargs)
      fi
    '';
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      lg = "lazygit";
      ld = "lazydocker";
      hms = "home-manager switch --flake ~/dotfiles#${host}";
    };
    plugins = with pkgs.nushellPlugins; [
      polars
    ];
    settings = {
      show_banner = false;
    };
    extraConfig = ''
      source ~/.config/nushell/scripts.nu
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

  programs.git = {
    enable = true;
    settings = {
      user.name = "sirex";
      user.email = "sirexas@gmail.com";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      hunk-header-style = "omit";
      dark = true;
      syntax-theme = "tokyonight";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      git = {
        pagers = [
          {
            pager = "delta --dark --paging=never";
            colorArg = "always";
          }
        ];
      };
      gui.theme = {
        selectedRangeBgColor = [ "#292e42" ];
        selectedLineBgColor = [ "#292e42" ];
      };
    };
  };

  programs.lazydocker = {
    enable = true;
    settings = {
      gui.returnImmediately = true;
      customCommands = {
        services = [
          {
            name = "bash";
            attach = true;
            command = "docker compose run --rm {{ .Service.Name }} bash";
          }
          {
            name = "bash (root)";
            attach = true;
            command = "docker compose run --rm --user root {{ .Service.Name }} bash";
          }
        ];
      };
    };
  };

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

  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight";
      style = "plain";
      paging = "never";
    };
    themes = {
      tokyonight = {
        src = pkgs.fetchFromGitHub {
          owner = "folke";
          repo = "tokyonight.nvim";
          rev = "main";
          sha256 = "sha256-a9iRWue7DB7s/wNdxqqB51Jya5P9X6sDftqhdmKggU0=";
        };
        file = "extras/sublime/tokyonight_night.tmTheme";
      };
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      autoupdate = false;
    };
    tui = {
      theme = "tokyonight";
    };
  };

  home.file = {
    ".config/zsh/themes/sirex.zsh-theme".source = ./zsh/themes/sirex.zsh-theme;
  };

  xdg.configFile = {
    "kitty".source = link "kitty";
    "niri".source = link "niri";
    "yazi".source = link "yazi";
    "kanshi".source = link "kanshi";
    "nushell/scripts.nu".source =link "nushell/scripts.nu";
    "opencode/agents".source = link "opencode/agents";
  };
}
