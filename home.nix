# { config, pkgs, nixvim, ... }:
{ config, pkgs, host, hasNotes ? false, ... }:
let
  # lua = func: {
  #   __raw = ''
  #     function(...)
  #       return require('utils').${func}(...)
  #     end
  #   '';
  # };
  lua = func: args: {
    __raw = ''
      function()
        return require('utils').${func}(${builtins.concatStringsSep ", " (map builtins.toJSON args)})
      end
    '';
  };

  link = path:
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/${path}";
in
{
  # imports = [
  #   nixvim.homeManagerModules.nixvim
  # ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sirex";
  home.homeDirectory = "/home/sirex";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    nh
    fd
    ripgrep
    matugen
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sirex/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    localVariables = {
      HIST_STAMPS = "mm/dd/yyyy"; 
    };
    shellAliases = {
      lg = "lazygit";
      hms = "home-manager switch --flake ~/dotfiles#${host}";
    };
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.config/zsh";
      theme = "sirex";
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
  programs.bat.enable = true;
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
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    enableZshIntegration = true;
  };

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

    keymaps = [
      # Basic
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; options.desc = "Clear highlights"; }
      { mode = ["i" "x" "n" "s"]; key = "<C-s>"; action = "<cmd>up<cr><esc>"; options.desc = "Save File"; }
      { mode = "n"; key = "<leader>ch"; action = "<cmd>e ~/dotfiles/home.nix<cr>"; options.desc = "[C]onfigure [H]ome.nix"; }
      { mode = "n"; key = "<leader>cn"; action = "<cmd>e ~/dotfiles/niri/config.kdl<cr>"; options.desc = "[C]onfigure [N]iri"; }
      { mode = "n"; key = "<leader>cv"; action = lua "neovim_configs" []; options.desc = "[C]onfigure Neo[V]im"; }

      # Movement (better up/down)
      { mode = ["n" "x"]; key = "j"; action = "v:count == 0 ? 'gj' : 'j'"; options = { expr = true; silent = true; desc = "Down"; }; }
      { mode = ["n" "x"]; key = "k"; action = "v:count == 0 ? 'gk' : 'k'"; options = { expr = true; silent = true; desc = "Up"; }; }

      # Window Navigation
      { mode = "n"; key = "<Tab>"; action = "<C-W>p"; options.desc = "Switch to previous window"; }
      { mode = "n"; key = "<C-Tab>"; action = "<C-6>"; options.desc = "Switch to previous buffer"; }
      { mode = "n"; key = "<C-h>"; action = "<C-w><C-h>"; options.desc = "Move left"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w><C-l>"; options.desc = "Move right"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w><C-j>"; options.desc = "Move down"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w><C-k>"; options.desc = "Move up"; }

      # Window Resizing
      { mode = "n"; key = "<C-M-n>"; action = "<cmd>vertical resize -5<CR>"; options = { silent = true; desc = "Decrease window width"; }; }
      { mode = "n"; key = "<C-M-m>"; action = "<cmd>vertical resize +5<CR>"; options = { silent = true; desc = "Increase window width"; }; }
      { mode = "n"; key = "<C-n>"; action = "<cmd>resize -5<CR>"; options = { silent = true; desc = "Decrease window height"; }; }
      { mode = "n"; key = "<C-m>"; action = "<cmd>resize +5<CR>"; options = { silent = true; desc = "Increase window height"; }; }

      # Scrolling
      { mode = "n"; key = "<A-j>"; action = "<c-d>"; options.desc = "Half page down"; }
      { mode = "n"; key = "<A-k>"; action = "<c-u>"; options.desc = "Half page up"; }

      # Terminal Mode Navigation
      { mode = "t"; key = "<Esc><Esc>"; action = "<C-\\><C-n>"; options.desc = "Exit terminal mode"; }
      { mode = "t"; key = "<C-h>"; action = "<C-\\><C-n><C-w><C-h>"; options.desc = "Move left (term)"; }
      { mode = "t"; key = "<C-l>"; action = "<C-\\><C-n><C-w><C-l>"; options.desc = "Move right (term)"; }
      { mode = "t"; key = "<C-j>"; action = "<C-\\><C-n><C-w><C-j>"; options.desc = "Move down (term)"; }
      { mode = "t"; key = "<C-k>"; action = "<C-\\><C-n><C-w><C-k>"; options.desc = "Move up (term)"; }

      # Diagnostics
      { mode = "n"; key = "<leader>q"; action.__raw = "vim.diagnostic.setloclist"; options.desc = "Open diagnostic Quickfix"; }

      # Toggle Term
      { mode = "n"; key = "<C-Enter>"; action = "<cmd>ToggleTerm<cr>"; options.desc = "Toggle terminal panel"; }
      { mode = "n"; key = "<C-e>"; action = "<cmd>ToggleTermSendCurrentLine<cr>j"; options.desc = "Send line to terminal"; }
      { mode = "v"; key = "<C-e>"; action = "<cmd>ToggleTermSendVisualSelection<cr>"; options.desc = "Send selection to terminal"; }
      { mode = "n"; key = "<leader>tm"; action = lua "set_term_cmd" []; options.desc = "[T]erminal [M]ap (Current Line)"; }
      { mode = "n"; key = "<leader>tt"; action = lua "run_term_cmd" []; options.desc = "Execute mapped terminal command"; }

      # projects.nvim
      { mode = "n"; key = "<leader>fp"; action = lua "projects" []; options.desc = "[F]ind a [P]roject"; }
      { mode = "n"; key = "<leader>sr"; action = "<cmd>ProjectRoot<cr>"; options.desc = "[S]et Project [R]oot"; }

      # Telescope
      { mode = "n"; key = "<leader><leader>"; action = lua "mru" []; options.desc = "[F]ind existing buffers (MRU)"; }
      { mode = "n"; key = "<leader>sd"; action = lua "search_dir" []; options.desc = "[S]earch [D]irectory"; }
      { mode = "n"; key = "<leader>cd"; action = lua "find" [ "~/dotfiles" ];  options.desc = "[C]onfigure [D]otfiles"; }
      { mode = "n"; key = "<leader>cc"; action = lua "find" [ "~/.config" ];  options.desc = "[C]onfigure .[c]onfig/"; }

      # Obsidian
      { mode = "n"; key = "<leader>oo"; action = "<cmd>Obsidian today<cr>"; options.desc = "Obsidian daily note"; }
      { mode = "n"; key = "<leader>ow"; action = "<cmd>Obsidian workspace<cr>"; options.desc = "Obsidian select workspace"; }
      { mode = "n"; key = "<leader>op"; action = "<cmd>Obsidian today -1<cr>"; options.desc = "Obsidian daily note (previous day)"; }
      { mode = "n"; key = "<leader>oy"; action = "<cmd>Obsidian yesterday<cr>"; options.desc = "Obsidian daily note (yesterday)";  }
      { mode = "n"; key = "<leader>or"; action = "<cmd>Obsidian backlinks<cr>"; options.desc = "Obsidian backlinks"; }
      { mode = "n"; key = "<leader>oi"; action = "<cmd>Obsidian paste_img<cr>"; options.desc = "Obsidian paste image"; }
      # Note: 'toc' is not a default command in recent versions. 
      # If this doesn't work, try a specific plugin for TOC or check command name.
      { mode = "n"; key = "<leader>ot"; action = "<cmd>Obsidian toc<cr>"; options.desc = "Obsidian table of content"; }
      { mode = "n"; key = "<leader>oe"; action = "<cmd>Obsidian open<cr>"; options.desc = "Open note in Obsidian app"; }
      { mode = "n"; key = "<leader>os"; action = "<cmd>Obsidian search<cr>"; options.desc = "Search Obsidian note"; }

      # LazyGit
      { mode = "n"; key = "<leader>gg"; action = "<cmd>LazyGitCurrentFile<cr>"; options.desc = "LazyGit (Current File)"; }
      { mode = "n"; key = "<leader>gl"; action = "<cmd>LazyGitFilterCurrentFile<cr>"; options.desc = "LazyGit Log (Current File)"; }
      { mode = "n"; key = "<leader>gL"; action = "<cmd>LazyGitFilter<cr>"; options.desc = "LazyGit Log (Project)"; }

      # Gitsigns
      { mode = "n"; key = "<leader>gb"; action = "<cmd>Gitsigns blame<cr>"; options.desc = "Git blame (File)"; }
      { mode = "n"; key = "<leader>gB"; action = "<cmd>Gitsigns blame_line<cr>"; options.desc = "Git blame (Line)"; }
      { mode = "n"; key = "<leader>gd"; action = "<cmd>Gitsigns diffthis<cr>"; options.desc = "Git diff (Against Index)"; }
      { mode = "n"; key = "<leader>ga"; action = "<cmd>Gitsigns stage_hunk<cr>"; options.desc = "Git stage hunk"; }
      { mode = "n"; key = "<leader>g-"; action = "<cmd>Gitsigns undo_stage_hunk<cr>"; options.desc = "Git undo stage hunk"; }

      # Oil
      { mode = "n"; key = "-"; action = "<cmd>Oil<cr>"; options.desc = "Oil: File browser"; }

      # CSVView
      { mode = "n"; key = "<leader>st"; action = "<cmd>CsvViewToggle<cr>"; options.desc = "Toggle CSV View"; }
    ];

    # Here is where we add your requested plugins
    plugins = {
      web-devicons.enable = true;

      # Project management
      project-nvim = {
        enable = true;
        enableTelescope = true;
        settings = {
          manual_mode = true;
          patterns = [
            ".git"
            ".obsidian"
            "lua"
            "Makefile"
            "package.json"
          ];
        };
      };

      # Obsidian integration
      obsidian = {
        enable = hasNotes;
        settings = {
          workspaces = [
            { name = "home"; path = "${config.home.homeDirectory}/notes"; }
            { name = "work"; path = "${config.home.homeDirectory}/ivpk/notes"; }
            # {
            #   # https://github.com/obsidian-nvim/obsidian.nvim/issues/418
            #   name = "auto";
            #   path.__raw = ''
            #     function()
            #       local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
            #       local prev = ""
            #       while path ~= "" and path ~= prev do
            #         if vim.uv.fs_stat(path .. "/.obsidian") then
            #           return path
            #         end
            #         prev, path = path, vim.fs.dirname(path)
            #       end
            #       return nil
            #     end
            #   '';
            # }
          ];

          daily_notes = {
            folder = "timelog";
            date_format = "%Y/%Y-%m-%d";
            alias_format = "%Y-%m-%d";
          };

          new_notes_location = "current_dir";
          preferred_link_style = "wiki";
          wiki_link_func = "use_alias_only";

          attachments = {
            # attachments.img_folder is deprecated, use attachments.folder instead.
            folder = "files";
            confirm_img_paste = false;
            # Replicating img_name_func
            img_name_func = lua "img_name" [];
          };

          # Custom Note ID Logic
          note_id_func = lua "note_id" [];

          ui.enable = false;
          legacy_commands = false;

          completion = {
            nvim_cmp = true;
            min_chars = 2;
          };
        };
      };

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
          "<leader>fs" = { action = "builtin"; options.desc = "[F]ind [S]elect Telescope"; };
          "<leader>fw" = { action = "grep_string"; options.desc = "[F]ind current [W]ord"; };
          "<leader>fe" = { action = "diagnostics"; options.desc = "[F]ind [E]rrors"; };
          "<leader>fr" = { action = "oldfiles"; options.desc = "[F]ind [R]ecent files"; };
          "<leader>f." = { action = "resume"; options.desc = "[F]ind [R]esume"; };
          "<leader>fm" = { action = "man_pages"; options.desc = "[F]ind [M]an pages"; };
          "<leader>ss" = { action = "live_grep"; options.desc = "[S]earch"; };
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

          sources = [
            { name = "obsidian"; }
            { name = "obsidian_new"; }
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

  home.file = {
    ".config/zsh/themes/sirex.zsh-theme".source = ./zsh/themes/sirex.zsh-theme;
    ".local/share/applications/obsidian.desktop".text = ''
      [Desktop Entry]
      Name=Obsidian
      Comment=Obsidian (Wayland)
      Exec=/usr/bin/obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland %U
      Terminal=false
      Type=Application
      Icon=obsidian
      MimeType=x-scheme-handler/obsidian;
      Categories=Office;
      StartupNotify=true
      StartupWMClass=obsidian
    '';
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
