{ ... }:
{
  programs.nixvim.plugins.lsp = {
    enable = true;
    servers = {
      pyright.enable = true;
      nixd.enable = true;
    };
    keymaps.lspBuf = {
      "gd" = "definition";
      "gr" = "references";
      "K" = "hover";
      "<C-k>" = "signature_help";
      "<leader>ln" = { action = "rename"; desc = "[L]SP Code re[N]ame"; };
      "<leader>la" = { action = "code_action"; desc = "[L]SP Code [A]ction"; };
      "<leader>lf" = { action = "format"; desc = "[L]SP [F]ormat"; };
    };
  };
}
