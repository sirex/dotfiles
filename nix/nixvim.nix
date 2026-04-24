{ config, pkgs, lib, ... }:
let
  lua = func: args: {
    __raw = let
      configArgs = builtins.concatStringsSep ", " (map builtins.toJSON args);
      allArgs = if configArgs == "" then "..." else "${configArgs}, ...";
    in ''
      function(...)
        return require('utils').${func}(${allArgs})
      end
    '';
  };
in
{
  _module.args.lua = lua;

  imports = [
    ./nixvim/keymaps.nix
    ./nixvim/whichkey.nix
    ./nixvim/telescope.nix
    ./nixvim/cmp.nix
    ./nixvim/lsp.nix
    ./nixvim/obsidian.nix
    ./nixvim/csv.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    extraFiles = {
      "lua/utils.lua".source = ./utils.lua;
      "lua/snippets.lua".source = ./snippets.lua;
    };

    extraConfigLua = ''
      require("utils").dotenv()
      require("snippets")
    '';

    globals = {
      mapleader = " ";
      maplocalleader = ",";
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

      termguicolors = true;
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
      nui.enable = true;          # UI Component Library
      web-devicons.enable = true;

      toggleterm = {
        enable = true;
        settings = {
          size = 15;
          open_mapping = "[[<C-Enter>]]";
          direction = "horizontal";
          shell = "nu";
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

      neogit = {
        enable = true;
        settings = {
          kind = "split";
          commit_popup.kind = "split";
        };
      };

      gitlinker = {
        enable = true;
        settings = {
          mappings = null;
        };
      };

      diffview = {
        enable = true;
      };

      mini-files = {
        enable = true;
        settings = {
          mappings = {
            go_in_plus = "l";
            synchronize = "s";
          };
          windows = {
            preview = true;
          };
        };
      };

      yazi.enable = true;

      neo-tree.enable = true;

      treesitter = {
        enable = true;
        nixvimInjections = true;
        languageRegister = {
          markdown = [ "octo" ];
        };
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

      # 2. Enable Tmux Navigation
      # This automatically sets up the Ctrl-h/j/k/l bindings in Neovim
      tmux-navigator.enable = true;

      trouble.enable = true;

      nvim-autopairs.enable = true;

      colorizer = {
        enable = true;
        settings.user_default_options.names = false;
      };

      octo = {
        enable = true;
        settings = {
          # Enable Projects V2 timeline events
          default_to_projects_v2 = true;

          isseus.order_by = {
            filed = "UPDATED_AT";
            direction = "DESC";
          };
        };
      };

      codecompanion = {
        enable = true;
        settings = {
          strategies = {
            chat.adapter = "gemini";
            inline.adapter = "gemini";
          };
          adapters = {
            gemini.__raw = ''
              function()
                return require("codecompanion.adapters").extend("gemini", {
                  schema = {
                    model = {
                      default = "gemini-3-flash"
                    }
                  },
                  env = {
                    api_key = "GEMINI_API_KEY",
                  },
                })
              end,
            '';
          };
        };
      };

      treesj.enable = true;

      flash = {
        enable = true;
        settings = {
          label.uppercase = false;
          modes.search.enabled = true;
        };
      };

    };

  };


}
