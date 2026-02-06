{ ... }:
{
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
}
