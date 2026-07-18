{ pkgs, ... }:
{
  xdg.mimeApps = {
    defaultApplications = {
      "image/jpg"     = "imv-dir.desktop";
      "image/jpeg"    = "imv-dir.desktop";
      "image/png"     = "imv-dir.desktop";
      "image/bmp"     = "imv-dir.desktop";
      "image/gif"     = "imv-dir.desktop";
      "image/tiff"    = "imv-dir.desktop";
      "image/webp"    = "imv-dir.desktop";
      "image/svg+xml" = "imv-dir.desktop";
      "image/heic"    = "imv-dir.desktop";
      "image/avif"    = "imv-dir.desktop";
      "image/jp2"     = "imv-dir.desktop";
      "image/jxl"     = "imv-dir.desktop";
    };
  };

  # Shadow /usr/bin/imv-dir with a version that sizes imv's initial window to
  # the first image's pixel dimensions, clamped to 90% of the focused niri
  # output. Mirrors upstream imv-dir semantics (multi-arg -> bare imv; single
  # file -> open its whole directory starting at the file). Installed to
  # ~/.nix-profile/bin/imv-dir, ahead of /usr/bin on PATH.
  home.packages = [
    (pkgs.writeShellScriptBin "imv-dir" ''
      # Multi-arg: identical to upstream -- just hand all args to imv.
      if [ $# -ge 2 ]; then
        exec imv "$@"
      fi

      target="$1"
      if [ -z "$target" ]; then
        exec imv
      fi
      dir="$(dirname "$target")"

      # Probe the image's intrinsic pixel dimensions. Try ImageMagick's
      # `identify` first (handles most raster + svg via its delegates), fall
      # back to `file` (covers PNG/JPEG/GIF/BMP/TIFF/WebP natively).
      img_w=""
      img_h=""
      if command -v identify >/dev/null 2>&1; then
        dims="$(identify -format '%w %h' "$target" 2>/dev/null)"
        if [ -n "$dims" ]; then
          img_w="''${dims%% *}"
          img_h="''${dims##* }"
        fi
      fi
      if [ -z "$img_w" ] || [ "$img_w" = "0" ]; then
        info="$(file -b "$target" 2>/dev/null)"
        dims="$(printf '%s' "$info" | sed -n 's/.* \([0-9][0-9]*\) x \([0-9][0-9]*\).*/\1 \2/p')"
        if [ -n "$dims" ]; then
          img_w="''${dims%% *}"
          img_h="''${dims##* }"
        fi
      fi

      # No dimensions obtainable (e.g. exotic format) -- launch with imv
      # defaults.
      if [ -z "$img_w" ] || [ -z "$img_h" ] || [ "$img_w" = "0" ] || [ "$img_h" = "0" ]; then
        exec imv -n "$target" "$dir"
      fi

      # Focused output logical size for clamping. Fall back to 1920x1080 if
      # niri isn't available (e.g. server host or X11 session).
      out_w="1920"
      out_h="1080"
      if command -v niri >/dev/null 2>&1; then
        line="$(niri msg focused-output 2>/dev/null | awk '/Logical size:/ {print $3; exit}')"
        if [ -n "$line" ]; then
          ow="''${line%x*}"
          oh="''${line#*x}"
          if [ -n "$ow" ] && [ -n "$oh" ] && [ "$ow" != "0" ] && [ "$oh" != "0" ]; then
            out_w="$ow"
            out_h="$oh"
          fi
        fi
      fi

      max_w=$((out_w * 90 / 100))
      max_h=$((out_h * 90 / 100))

      new_w=$img_w
      new_h=$img_h
      if [ "$new_w" -gt "$max_w" ] || [ "$new_h" -gt "$max_h" ]; then
        # Fit inside max_w x max_h preserving aspect ratio.
        if [ $((new_w * max_h)) -gt $((new_h * max_w)) ]; then
          new_w=$max_w
          new_h=$((img_h * max_w / img_w))
        else
          new_h=$max_h
          new_w=$((img_w * max_h / img_h))
        fi
      fi

      exec imv -W "$new_w" -H "$new_h" -n "$target" "$dir"
    '')
  ];
}