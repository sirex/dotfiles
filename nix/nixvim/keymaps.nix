{ config, pkgs, hasNotes ? false, ... }:
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
  programs.nixvim.keymaps = [
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

    # Notes
    { mode = "n"; key = "<leader>nc"; action = lua "create_note" []; options.desc = "[C]reate new [N]ote"; }
    { mode = "n"; key = "<leader>nn"; action = lua "latest_note" []; options.desc = "[N]ewest [N]ote"; }
  ];
}
