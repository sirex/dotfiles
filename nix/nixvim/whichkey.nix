{ ... }:
{
  programs.nixvim.plugins.which-key = {
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
        { __unkeyed-1 = "<leader>f"; group = "[F]find"; }
        { __unkeyed-1 = "<leader>g"; group = "[G]it"; }
        { __unkeyed-1 = "<leader>r"; group = "[R]ename"; }
        { __unkeyed-1 = "<leader>s"; group = "[S]et or [S]earch"; }
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
}
