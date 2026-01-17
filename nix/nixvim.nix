{ config, pkgs, lib, ... }:
let
  lua = func: args: {
    __raw = ''
      function()
        return require('utils').${func}(${builtins.concatStringsSep ", " (map builtins.toJSON args)})
      end
    '';
  };
in
{
  _module.args.lua = lua;

  imports = [
    ./nixvim/keymaps.nix
    ./nixvim/obsidian.nix
    ./nixvim/projects.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraFiles = {
      "lua/utils.lua".source = ./utils.lua;
      "lua/snippets.lua".source = ./snippets.lua;
    };

    extraConfigLua = ''
      require("snippets")
    '';

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # The settings you'd usually put in init.lua
    opts = {
      number = true;  # Line numbers
      mouse = "a";
      hlsearch = false;
      timeout = true;
      clipboard = "unnamedplus";
      splitright = true;
      splitbelow = true;
      updatetime = 250;  # Decrease update time
      timeoutlen = 300;  # Decrease mapped sequence wait time
      undofile = true;
      breakindent = true;
      signcolumn = "yes";  # Keep signcolumn on by default
      inccommand = "split";  # Preview substitutions live, as you type!
      cursorline = true;  # Show which line your cursor is on
      scrolloff = 10;  # Minimal number of screen lines to keep above and below the cursor.
      spelllang = ["lt" "en"];
      linebreak = true;

      # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
      # instead raise a dialog asking if you wish to save the current file(s)
      # See `:help 'confirm'`
      confirm = true;

      # Sets how neovim will display certain whitespace characters in the editor.
      #  See `:help 'list'`
      #  and `:help 'listchars'`
      list = true;
      listchars = { tab = "» "; trail = "·"; nbsp = "␣"; };

      # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      ignorecase = true;
      smartcase = true;

      # Tabs
      expandtab = true;  # Convert tabs to spaces
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
    };

    colorschemes.tokyonight = {
      enable = true;
      settings = {
        style = "night"; 
        styles = {
          comments = { italic = false; };
        };
      };
    };

    # Here is where we add your requested plugins
    plugins = {
      web-devicons.enable = true;

      which-key = {
        enable = true;

        # These settings replicate your 'opts' block
        settings = {
          delay = 0;
          icons = {
            # Nixvim will evaluate this boolean at build time
            # You can set this to true if you are using Nerd Fonts
            mappings = true; 
          };

          # This replicates your 'spec' block for documenting key groups
          spec = [
            { __unkeyed-1 = "<leader>c"; group = "[C]ode"; mode = ["n" "x"]; }
            { __unkeyed-1 = "<leader>d"; group = "[D]ocument"; }
            { __unkeyed-1 = "<leader>f"; group = "[F] find"; }
            { __unkeyed-1 = "<leader>g"; group = "[G]it"; }
            { __unkeyed-1 = "<leader>r"; group = "[R]ename"; }
            { __unkeyed-1 = "<leader>s"; group = "[S]et option"; }
            { __unkeyed-1 = "<leader>v"; group = "Neo[V]im"; }
            { __unkeyed-1 = "<leader>w"; group = "[W]orkspace"; }
            { __unkeyed-1 = "<leader>t"; group = "[T]erminal"; }
            { __unkeyed-1 = "<leader>h"; group = "Git [H]unk"; mode = ["n" "v"]; }
            { __unkeyed-1 = "<leader>o"; group = "[O]bsidian"; }
            { __unkeyed-1 = "<leader>x"; group = "Quickfi[X]/Diagnostics"; }
            { __unkeyed-1 = "["; group = "Prev"; }
            { __unkeyed-1 = "]"; group = "Next"; }
            { __unkeyed-1 = "g"; group = "[G]oto"; }
            { __unkeyed-1 = "gs"; group = "[S]urround"; }
            { __unkeyed-1 = "gx"; desc = "Open with e[X]ternal app"; }
            { __unkeyed-1 = "z"; group = "[F]old"; }
          ];
        };
      };

      telescope = {
        enable = true;

        # Telescope Settings (Defaults)
        settings.defaults = {
          path_display = [ "filename_first" ];

          mappings = {
            n = {
              "<C-p>" = { __raw = "require('telescope.actions.layout').toggle_preview"; };
            };
            i = {
              "<C-j>" = "move_selection_next";
              "<C-k>" = "move_selection_previous";
              "<M-j>" = "preview_scrolling_down";
              "<M-k>" = "preview_scrolling_up";
              "<C-p>" = { __raw = "require('telescope.actions.layout').toggle_preview"; };
              "<esc>" = "close";
              "<C-u>" = false;
            };
          };
        };

        # Extension Setup
        extensions = {
          fzf-native.enable = true; # Nix handles the build process automatically!
          ui-select = {
            enable = true;
            settings = {
              # This replicates require("telescope.themes").get_dropdown()
              __raw = "require('telescope.themes').get_dropdown()";
            };
          };
        };

        # Standard Keymaps (Simple built-in pickers)
        keymaps = {
          "<leader>fh" = { action = "help_tags"; options.desc = "[F]ind [H]elp"; };
          "<leader>fk" = { action = "keymaps"; options.desc = "[F]ind [K]eymaps"; };
          "<leader>ff" = { action = "find_files"; options.desc = "[F]ind [F]iles"; };
          "<leader>ft" = { action = "builtin"; options.desc = "[F]ind Select [T]elescope"; };
          "<leader>fe" = { action = "diagnostics"; options.desc = "[F]ind [E]rrors"; };
          "<leader>fr" = { action = "oldfiles"; options.desc = "[F]ind [R]ecent files"; };
          "<leader>f." = { action = "resume"; options.desc = "[F]ind [R]esume"; };
          "<leader>fm" = { action = "man_pages"; options.desc = "[F]ind [M]an pages"; };
          "<leader>ss" = { action = "live_grep"; options.desc = "[S]earch"; };
          "<leader>sw" = { action = "grep_string"; options.desc = "[F]ind current [W]ord"; };
        };
      };

      toggleterm = {
        enable = true;
        settings = {
          size = 15;
          open_mapping = "[[<C-Enter>]]";
          direction = "horizontal";
          shell = "zsh";
          auto_scroll = true;
          insert_mappings = false;
        };
      };

      lazygit.enable = true;

      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add = { text = "+"; };
            change = { text = "~"; };
            delete = { text = "_"; };
            topdelete = { text = "‾"; };
            changedelete = { text = "~"; };
          };
        };
      };

      oil = {
        enable = true;
        settings = {
          delete_to_trash = true;
          keymaps = {
            # Complex actions with options require an attribute set
            "<C-CR>" = { __unkeyed-1 = "actions.select"; opts = { horizontal = true; }; };
            "<S-CR>" = { __unkeyed-1 = "actions.select"; opts = { vertical = true; }; };
            "<C-r>" = "actions.refresh";

            # Restore global keymaps inside the Oil buffer
            "<C-s>" = "<CMD>write<CR>";
            "<C-h>" = "<C-w><C-h>";
            "<C-l>" = "<C-w><C-l>";
          };
        };
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
        ensureInstalled = [ 
          "bash"
          "c"
          "diff"
          "html"
          "xml"
          "lua"
          "luadoc"
          "markdown"
          "markdown_inline"
          "query"
          "vim"
          "vimdoc"
          "python"
          "nix" 
          "kdl"
        ];
        settings = {
          auto_install = false;
          sync_install = false;
          # parser_install_dir.__raw = "vim.fs.joinpath(vim.fn.stdpath('data'), 'treesitter')";
          highlight.enable = true;
          highlight.additional_vim_regex_highlighting = false;
          indent.enable = true;
        };
        nixGrammars = true;
      };

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

      lsp = {
        enable = true;
        servers = {
          # You can add language servers here later, e.g., nil_ls = { enable = true; };
        };
      };

      csvview = {
        enable = true;
        settings = {
          keymaps = {
            jump_next_field_end = { __unkeyed-1 = "<Tab>"; mode = [ "n" "v" ]; };
            jump_prev_field_end = { __unkeyed-1 = "<S-Tab>"; mode = [ "n" "v" ]; };
            jump_next_row = { __unkeyed-1 = "<Enter>"; mode = [ "n" "v" ]; };
            jump_prev_row = { __unkeyed-1 = "<S-Enter>"; mode = [ "n" "v" ]; };
          };
        };
      };

    };
  };


}
