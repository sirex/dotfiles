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
    bat        # Cat with colors
    matugen
    poppler    # PDF previews
    ffmpegthumbnailer # Video thumbnais
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
      custom = "$HOME/.config/zsh";
      theme = "sirex";
    };
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
