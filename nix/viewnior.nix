{ pkgs, ... }:
{
  xdg.mimeApps = {
    defaultApplications = {
      "image/jpg"     = "viewnior.desktop";
      "image/jpeg"    = "viewnior.desktop";
      "image/png"     = "viewnior.desktop";
      "image/bmp"     = "viewnior.desktop";
      "image/gif"     = "viewnior.desktop";
      "image/tiff"    = "viewnior.desktop";
      "image/webp"    = "viewnior.desktop";
      "image/svg+xml" = "viewnior.desktop";
      "image/heic"    = "viewnior.desktop";
      "image/avif"    = "viewnior.desktop";
      "image/jp2"     = "viewnior.desktop";
      "image/jxl"     = "viewnior.desktop";
    };
  };

  home.packages = [
    pkgs.viewnior
  ];
}