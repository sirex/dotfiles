{ pkgs, config, ... }:
{

  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      beancount
      beangulp
    ]))

    fava
  ];

  programs.nushell = {
    environmentVariables = {
      beancount_file = "${config.home.homeDirectory}/notes/finansai.beancount";
    };
    shellAliases = {
      bc = "bean-check $env.beancount_file";
      br = "bean-report $env.beancount_file";
      fv = "fava $env.beancount_file";
    };
  };

  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.vim-beancount
    ];

    keymaps = [
      {
        mode = "n";
        key = "<leader>ba";
        action = ":AlignCommodity<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Align Beancount Commodities";
        };
      }
    ];
  };

}
