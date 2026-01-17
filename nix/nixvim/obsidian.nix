{ config, lua, hasNotes ? false, ... }:
{
  programs.nixvim.keymaps = [
    { mode = "n"; key = "<leader>oo"; action = "<cmd>Obsidian today<cr>"; options.desc = "Obsidian daily note"; }
    { mode = "n"; key = "<leader>ow"; action = "<cmd>Obsidian workspace<cr>"; options.desc = "Obsidian select workspace"; }
    { mode = "n"; key = "<leader>op"; action = "<cmd>Obsidian today -1<cr>"; options.desc = "Obsidian daily note (previous day)"; }
    { mode = "n"; key = "<leader>oy"; action = "<cmd>Obsidian yesterday<cr>"; options.desc = "Obsidian daily note (yesterday)";  }
    { mode = "n"; key = "<leader>or"; action = "<cmd>Obsidian backlinks<cr>"; options.desc = "Obsidian backlinks"; }
    { mode = "n"; key = "<leader>oi"; action = "<cmd>Obsidian paste_img<cr>"; options.desc = "Obsidian paste image"; }
    { mode = "n"; key = "<leader>ot"; action = "<cmd>Obsidian toc<cr>"; options.desc = "Obsidian table of content"; }
    { mode = "n"; key = "<leader>oe"; action = "<cmd>Obsidian open<cr>"; options.desc = "Open note in Obsidian app"; }
    { mode = "n"; key = "<leader>os"; action = "<cmd>Obsidian search<cr>"; options.desc = "Search Obsidian note"; }
  ];

  programs.nixvim.plugins.obsidian = {
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

  home.file = {
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

}
