{ config, pkgs, ... }:
{
  programs.nvf = {
    enable = true;

    # Your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      debugMode = {
        enable = false;
        level = 16;
        logFile = "/tmp/nvim.log";
      };

      keymaps = [
        # Basic
        { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; desc = "Clear highlights"; }
        { mode = ["i" "x" "n" "s"]; key = "<C-s>"; action = "<cmd>up<cr><esc>"; desc = "Save File"; }
        { mode = "n"; key = "<leader>ch"; action = "<cmd>e ~/dotfiles/home.nix<cr>"; desc = "[C]onfigure [H]ome.nix"; }
        { mode = "n"; key = "<leader>cn"; action = "<cmd>e ~/dotfiles/niri/config.kdl<cr>"; desc = "[C]onfigure [N]iri"; }
        #~{ mode = "n"; key = "<leader>cv"; action = lua "neovim_configs" []; desc = "[C]onfigure Neo[V]im"; }

        # Movement (better up/down)
        { mode = ["n" "x"]; key = "j"; action = "v:count == 0 ? 'gj' : 'j'"; expr = true; silent = true; desc = "Down"; }
        { mode = ["n" "x"]; key = "k"; action = "v:count == 0 ? 'gk' : 'k'"; expr = true; silent = true; desc = "Up"; }

        # Window Navigation
        { mode = "n"; key = "<Tab>"; action = "<C-W>p"; desc = "Switch to previous window"; }
        { mode = "n"; key = "<C-Tab>"; action = "<C-6>"; desc = "Switch to previous buffer"; }
        { mode = "n"; key = "<C-h>"; action = "<C-w><C-h>"; desc = "Move left"; }
        { mode = "n"; key = "<C-l>"; action = "<C-w><C-l>"; desc = "Move right"; }
        { mode = "n"; key = "<C-j>"; action = "<C-w><C-j>"; desc = "Move down"; }
        { mode = "n"; key = "<C-k>"; action = "<C-w><C-k>"; desc = "Move up"; }

        # Window Resizing
        { mode = "n"; key = "<C-M-n>"; action = "<cmd>vertical resize -5<CR>"; silent = true; desc = "Decrease window width"; }
        { mode = "n"; key = "<C-M-m>"; action = "<cmd>vertical resize +5<CR>"; silent = true; desc = "Increase window width"; }
        { mode = "n"; key = "<C-n>"; action = "<cmd>resize -5<CR>"; silent = true; desc = "Decrease window height"; }
        { mode = "n"; key = "<C-m>"; action = "<cmd>resize +5<CR>"; silent = true; desc = "Increase window height"; }

        # Scrolling
        { mode = "n"; key = "<A-j>"; action = "<c-d>"; desc = "Half page down"; }
        { mode = "n"; key = "<A-k>"; action = "<c-u>"; desc = "Half page up"; }

        # Terminal Mode Navigation
        { mode = "t"; key = "<Esc><Esc>"; action = "<C-\\><C-n>"; desc = "Exit terminal mode"; }
        { mode = "t"; key = "<C-h>"; action = "<C-\\><C-n><C-w><C-h>"; desc = "Move left (term)"; }
        { mode = "t"; key = "<C-l>"; action = "<C-\\><C-n><C-w><C-l>"; desc = "Move right (term)"; }
        { mode = "t"; key = "<C-j>"; action = "<C-\\><C-n><C-w><C-j>"; desc = "Move down (term)"; }
        { mode = "t"; key = "<C-k>"; action = "<C-\\><C-n><C-w><C-k>"; desc = "Move up (term)"; }

        # Diagnostics
        #~{ mode = "n"; key = "<leader>q"; action.__raw = "vim.diagnostic.setloclist"; desc = "Open diagnostic Quickfix"; }

        # Toggle Term
        { mode = "n"; key = "<C-Enter>"; action = "<cmd>ToggleTerm<cr>"; desc = "Toggle terminal panel"; }
        { mode = "n"; key = "<C-e>"; action = "<cmd>ToggleTermSendCurrentLine<cr>j"; desc = "Send line to terminal"; }
        { mode = "v"; key = "<C-e>"; action = "<cmd>ToggleTermSendVisualSelection<cr>"; desc = "Send selection to terminal"; }
        #~{ mode = "n"; key = "<leader>tm"; action = lua "set_term_cmd" []; desc = "[T]erminal [M]ap (Current Line)"; }
        #~{ mode = "n"; key = "<leader>tt"; action = lua "run_term_cmd" []; desc = "Execute mapped terminal command"; }

        # LazyGit
        { mode = "n"; key = "<leader>gg"; action = "<cmd>LazyGitCurrentFile<cr>"; desc = "LazyGit (Current File)"; }
        { mode = "n"; key = "<leader>gl"; action = "<cmd>LazyGitFilterCurrentFile<cr>"; desc = "LazyGit Log (Current File)"; }
        { mode = "n"; key = "<leader>gL"; action = "<cmd>LazyGitFilter<cr>"; desc = "LazyGit Log (Project)"; }

        # Gitsigns
        { mode = "n"; key = "<leader>gb"; action = "<cmd>Gitsigns blame<cr>"; desc = "Git blame (File)"; }
        { mode = "n"; key = "<leader>gB"; action = "<cmd>Gitsigns blame_line<cr>"; desc = "Git blame (Line)"; }
        { mode = "n"; key = "<leader>gd"; action = "<cmd>Gitsigns diffthis<cr>"; desc = "Git diff (Against Index)"; }
        { mode = "n"; key = "<leader>ga"; action = "<cmd>Gitsigns stage_hunk<cr>"; desc = "Git stage hunk"; }
        { mode = "n"; key = "<leader>g-"; action = "<cmd>Gitsigns undo_stage_hunk<cr>"; desc = "Git undo stage hunk"; }

        # Oil
        { mode = "n"; key = "-"; action = "<cmd>Oil<cr>"; silent = true; desc = "Oil: File browser"; }

        # CSVView
        { mode = "n"; key = "<leader>st"; action = "<cmd>CsvViewToggle<cr>"; desc = "Toggle CSV View"; }

        # Notes
        #~{ mode = "n"; key = "<leader>nc"; action = lua "create_note" []; desc = "[C]reate new [N]ote"; }
        #~{ mode = "n"; key = "<leader>nn"; action = lua "latest_note" []; desc = "[N]ewest [N]ote"; }

        { mode = "n"; key = "<leader>oo"; action = "<cmd>Obsidian today<cr>"; desc = "Obsidian daily note"; }
        { mode = "n"; key = "<leader>ow"; action = "<cmd>Obsidian workspace<cr>"; desc = "Obsidian select workspace"; }
        { mode = "n"; key = "<leader>op"; action = "<cmd>Obsidian today -1<cr>"; desc = "Obsidian daily note (previous day)"; }
        { mode = "n"; key = "<leader>oy"; action = "<cmd>Obsidian yesterday<cr>"; desc = "Obsidian daily note (yesterday)";  }
        { mode = "n"; key = "<leader>or"; action = "<cmd>Obsidian backlinks<cr>"; desc = "Obsidian backlinks"; }
        { mode = "n"; key = "<leader>oi"; action = "<cmd>Obsidian paste_img<cr>"; desc = "Obsidian paste image"; }
        { mode = "n"; key = "<leader>ot"; action = "<cmd>Obsidian toc<cr>"; desc = "Obsidian table of content"; }
        { mode = "n"; key = "<leader>oe"; action = "<cmd>Obsidian open<cr>"; desc = "Open note in Obsidian app"; }
        { mode = "n"; key = "<leader>os"; action = "<cmd>Obsidian search<cr>"; desc = "Search Obsidian note"; }
      ];

      options = {
        hlsearch = false;
        cursorline = true;  # Show which line your cursor is on
        scrolloff = 10;  # Minimal number of screen lines to keep above and below the cursor.
        conceallevel = 1;
        linebreak = true;
        confirm = true;
        list = true;
        listchars = "tab:» ,trail:·,nbsp:␣";
        ignorecase = true;
        smartcase = true;
        expandtab = true;  # Convert tabs to spaces
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
      };
      searchCase = "smart";

      preventJunkFiles = true;
      undoFile = {
        enable = true;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      # spellcheck = {
      #   enable = true;
      #   languages = ["lt" "en"];
      #   programmingWordlist.enable = true;
      # };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false; # throws an annoying debug message
        neogit.enable = true;
      };

      telescope.enable = true;
      projects.project-nvim.enable = true;
      autocomplete.nvim-cmp.enable = true;

      notes = {
        obsidian = {
          enable = true;
          setupOpts = {
            workspaces = [
              { name = "home"; path = "${config.home.homeDirectory}/notes"; }
              { name = "work"; path = "${config.home.homeDirectory}/ivpk/notes"; }
            ];
          };
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        otter-nvim.enable = true;
        nvim-docs-view.enable = true;
        harper-ls.enable = true;
      };

      diagnostics = {
        enable = true;
        config = {
          signs = true;
          underline = false;
          update_in_insert = false;
        };
      };

      debugger.nvim-dap.enable = true;
      debugger.nvim-dap.ui.enable = true;

      languages = {
        bash.enable = true;
        css.enable = true;
        html.enable = true;
        json.enable = true;
        lua.enable = true;
        markdown.enable = true;
        nix.enable = true;
        python.enable = true;
        sql.enable = true;
        toml.enable = true;
      };

      utility = {
        oil-nvim.enable = true;
      };

      visuals = {
        nvim-web-devicons.enable = true;
        fidget-nvim.enable = true;

        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      statusline = {
        lualine = {
          enable = true;
          theme = "tokyonight";
        };
      };

      theme = {
        enable = true;
        name = "tokyonight";
        style = "night";
        transparent = true;
      };

      autopairs.nvim-autopairs.enable = true;
      snippets.luasnip.enable = true;
      filetree.neo-tree.enable = true;
      dashboard.alpha.enable = true;
      notify.nvim-notify.enable = true;
      treesitter.context.enable = true;

      terminal = {
        toggleterm = {
          enable = true;
          mappings.open = "<C-Enter>";
          lazygit.enable = true;
        };
      };

      ui = {
        borders.enable = true;
        colorizer.enable = true;
        breadcrumbs = {
          enable = true;
          navbuddy.enable = true;
        };
        smartcolumn.enable = true;
        fastaction.enable = true;
      };

      comments = {
        comment-nvim.enable = true;
      };

    };

  };
}
