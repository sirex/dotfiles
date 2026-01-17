{ config, lib, ... }:
{
  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>oo"; action = "<cmd>Obsidian today<cr>"; options.desc = "Obsidian daily note"; }
    { mode = "n"; key = "<leader>ow"; action = "<cmd>Obsidian workspace<cr>"; options.desc = "Obsidian select workspace"; }
    { mode = "n"; key = "<leader>op"; action = "<cmd>Obsidian today -1<cr>"; options.desc = "Obsidian daily note (previous day)"; }
    { mode = "n"; key = "<leader>oy"; action = "<cmd>Obsidian yesterday<cr>"; options.desc = "Obsidian daily note (yesterday)";  }
    { mode = "n"; key = "<leader>or"; action = "<cmd>Obsidian backlinks<cr>"; options.desc = "Obsidian backlinks"; }
    { mode = "n"; key = "<leader>oi"; action = "<cmd>Obsidian paste_img<cr>"; options.desc = "Obsidian paste image"; }
    { mode = "n"; key = "<leader>ot"; action = "<cmd>Obsidian toc<cr>"; options.desc = "Obsidian table of content"; }
    { mode = "n"; key = "<leader>oe"; action = "<cmd>Obsidian open<cr>"; options.desc = "Open note in Obsidian app"; }
    { mode = "n"; key = "<leader>os"; action = "<cmd>Obsidian search<cr>"; options.desc = "Search Obsidian note"; }
  ];

  programs.nixvim.plugins = {
    luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp_luasnip.enable = true;
    cmp = {
      enable = true;

      settings = {
        # Disable Auto-Popup
        completion.autocomplete = false;
        completion.completeopt = "menu,menuone,noinsert";

        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

        mapping = {
          # Trigger & Confirm (The Smart TAB)
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              local cmp = require('cmp')
              local luasnip = require('luasnip')

              if cmp.visible() then
                -- 1. If menu is open, confirm selection
                cmp.confirm({ select = true })
              
              elseif luasnip.locally_jumpable(1) then
                -- 2. If inside a snippet, jump to next placeholder
                luasnip.jump(1)

              else
                -- 3. Check for words to trigger manual completion
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                local has_words = col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil

                if has_words then
                  cmp.complete()
                else
                  fallback()
                end
              end
            end, { "i", "s" })
          '';

          # Navigation (Keep C-j/C-k or use Up/Down)
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";

          # Docs Scroll
          "<M-j>" = "cmp.mapping.scroll_docs(-4)";
          "<M-k>" = "cmp.mapping.scroll_docs(4)";

          # --- Snippet Jumping (Converted from your Lua) ---
          "<C-l>" = ''
            cmp.mapping(function()
              if require('luasnip').expand_or_locally_jumpable() then
                require('luasnip').expand_or_jump()
              end
            end, { "i", "s" })
          '';

          "<C-h>" = ''
            cmp.mapping(function()
              if require('luasnip').locally_jumpable(-1) then
                require('luasnip').jump(-1)
              end
            end, { "i", "s" })
          '';
        };

        sources =
          (lib.optionals config.programs.nixvim.plugins.obsidian.enable [
            { name = "obsidian"; }
            { name = "obsidian_new"; }
          ])
          ++ [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "nvim_lsp_signature_help"; }
        ];
      };
    };
  };
}
