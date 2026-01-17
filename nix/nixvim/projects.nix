{ lua, ... }:
{
  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>fp"; action = lua "projects" []; options.desc = "[F]ind a [P]roject"; }
    { mode = "n"; key = "<leader>sr"; action = "<cmd>ProjectRoot<cr>"; options.desc = "[S]et Project [R]oot"; }
  ];

  programs.nixvim.plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
    settings = {
      manual_mode = true;
      patterns = 
        [
        ".git"
        ".obsidian"
        "lua"
        "Makefile"
        "package.json"
      ];
    };
  };
}
