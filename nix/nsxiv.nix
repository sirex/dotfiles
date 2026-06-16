{ pkgs, ... }:
{
  xresources.properties = {
    "Nsxiv.window.background" = "#1b1a18";
    "Nsxiv.window.foreground" = "#c0caf5";
  };

  programs.zsh.shellAliases = {
    nsxiv = "nsxiv -b";
  };

  programs.nushell.shellAliases = {
    nsxiv = "nsxiv -b";
  };


  xdg.mimeApps = {
    defaultApplications = {
      "image/jpg"     = "nsxiv.desktop";
      "image/jpeg"    = "nsxiv.desktop";
      "image/png"     = "nsxiv.desktop";
      "image/bmp"     = "nsxiv.desktop";
      "image/gif"     = "nsxiv.desktop";
      "image/tiff"    = "nsxiv.desktop";
      "image/webp"    = "nsxiv.desktop";
      "image/svg+xml" = "nsxiv.desktop";
      "image/heic"    = "nsxiv.desktop";
      "image/avif"    = "nsxiv.desktop";
      "image/jp2"     = "nsxiv.desktop";
      "image/jxl"     = "nsxiv.desktop";
    };
  };

  home.packages = [
    (pkgs.writeShellScriptBin "nsxiv-wrapper" ''
      TARGET="$1"
      [ -z "$TARGET" ] && exit 1

      DIR="$(dirname "$TARGET")"

      count=1
      for file in "$DIR"/*; do
        [ "$file" = "$TARGET" ] && INDEX=$count
        count=$((count + 1))
      done

      # Call the explicit Nix store path for nsxiv to prevent loops
      exec ${pkgs.nsxiv}/bin/nsxiv -b -q -n "$INDEX" "$DIR"/*
      '')
  ];

  home.file = {
    ".local/share/applications/nsxiv.desktop".text = ''
      [Desktop Entry]
      Name=nsxiv
      # Pass only the single file path (%f) directly to the wrapper
      Exec=nsxiv-wrapper %f
      Type=Application
      Icon=nsxiv
      MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/png;image/tiff;image/webp;image/svg+xml;image/heic;image/avif;image/jp2;image/jxl;
      Categories=Graphics;Viewer;
      NoDisplay=true
    '';
  };


}
