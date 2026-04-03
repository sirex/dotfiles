{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
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

      treesitter.settings.highlight.disable = [
        "csv"
        "tsv"
      ];

    };

    extraPlugins = [
      pkgs.vimPlugins.rainbow_csv
    ];


    autoCmd = [
      {
        event = [ "FileType" ];
        pattern = [ "csv" "tsv" ];
        callback = {
          __raw = ''
            function(args)
              -- Safely stop Treesitter for the current buffer
              pcall(vim.treesitter.stop, args.buf)
              -- Force legacy syntax engine on
              vim.bo[args.buf].syntax = "on"
            end
          '';
        };
      }
    ];

  };

}
