{ config, lua, hasNotes ? false, ... }:
{
  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader><leader>"; action = lua "mru" []; options.desc = "[F]ind existing buffers (MRU)"; }
    { mode = "n"; key = "<leader>fd"; action = lua "search_dir" []; options.desc = "[S]earch [D]irectory"; }
    { mode = "n"; key = "<leader>cc"; action = lua "find" [ "~/dotfiles" ];  options.desc = "[C]onfigure Dotfiles"; }
    { mode = "n"; key = "<leader>c."; action = lua "find" [ "~/.config" ];  options.desc = "[C]onfigure .config/"; }
    { mode = "n"; key = "<leader>cd"; action.__raw = "require('telescope').extensions.zoxide.list"; options.desc = "Change directory (Zoxide)"; }
  ];

  programs.nixvim.plugins.telescope = {
    enable = true;

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
      "<leader>fs" = { action = "live_grep"; options.desc = "[F]ind [S]earch"; };
      "<leader>fw" = { action = "grep_string"; options.desc = "[F]ind [W]ord"; };
    };

    # Telescope Settings (Defaults)
    settings = {
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
          "<C-f>" = { __raw = "require('telescope.actions').to_fuzzy_refine"; };
        };
      };

      path_display = [ "filename_first" ];
      layout_strategy = "vertical";
      layout_config = {
        vertical = {
          preview_cutoff = 1; 
          mirror = false;
          preview_height = 0.4;
        };
      };
      
    };

    # Extension Setup
    extensions = {
      fzf-native.enable = true; # Nix handles the build process automatically!
      zoxide.enable = true;
      ui-select = {
        enable = true;
        settings = {
          # This replicates require("telescope.themes").get_dropdown()
          __raw = "require('telescope.themes').get_dropdown()";
        };
      };
    };
  };
}
