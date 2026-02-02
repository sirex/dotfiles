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
    ./nixvim/whichkey.nix
    ./nixvim/telescope.nix
    ./nixvim/projects.nix
    ./nixvim/cmp.nix
    ./nixvim/lsp.nix
    ./nixvim/obsidian.nix
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

      # 2. Enable Tmux Navigation
      # This automatically sets up the Ctrl-h/j/k/l bindings in Neovim
      plugins.tmux-navigator = {
        enable = true;
      };

    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "rainbow-csv";
        src = pkgs.fetchFromGitHub {
          owner = "mechatroner";
          repo = "rainbow_csv";
          rev = "master";
          hash = "sha256-Zf9VdRu/OF9h4AffOSAdM/Ypnla2wUp/iho3CV2YsH0=";
        };
      })
    ];

  };


}
