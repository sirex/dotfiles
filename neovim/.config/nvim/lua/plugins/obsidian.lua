-- https://github.com/epwalsh/obsidian.nvim
return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/notes",
      },
      {
        name = "work",
        path = "~/ivpk/notes",
      },
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "timelog",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y/%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%Y-%m-%d",
      -- Optional, default tags to add to each new daily note created.
      default_tags = {},
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil
    },
    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "current_dir",
    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",
    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "files", -- This is the default
    },
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      -- vim.fn.jobstart({"open", url})  -- Mac OS
      vim.fn.jobstart({ "xdg-open", url }) -- Linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,
  },
  keys = {
    { "<Leader>od", "<cmd>ObsidianToday<cr>",     desc = "Obsidian daily note" },
    { "<Leader>oD", "<cmd>ObsidianToday -1<cr>",  desc = "Obsidian daily note (previous day)" },
    { "<Leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian daily note (previous work day)" },
    { "<Leader>oy", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian backlinks" },
    { "<Leader>op", "<cmd>ObsidianPasteImg<cr>",  desc = "Obsidian passte image from clipboard" },
    { "<Leader>ot", "<cmd>ObsidianTOC<cr>",       desc = "Obsidian table of content" },
  },
}
