{ lua, ... }:
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        pyright.enable = true;
        nixd.enable = true;
        beancount.enable = true;
      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gr" = "references";
        "<leader>ln" = { action = "rename"; desc = "[L]SP Code re[N]ame"; };
        "<leader>la" = { action = "code_action"; desc = "[L]SP Code [A]ction"; };
        "<leader>lf" = { action = "format"; desc = "[L]SP [F]ormat"; };
      };
    };

    keymaps = [
      { mode = "n"; key = "K"; action = lua "help" []; options.desc = "[H]elp under cursor"; }
    ];

  };
}
