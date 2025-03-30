return {

  { "tomasiser/vim-code-dark" },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "codedark",
      colorscheme = "tokyonight-night",
    },
  },
  { "folke/flash.nvim",       enabled = false },
  { "hrsh7th/nvim-cmp",       enabled = false },
  { "saghen/blink.cmp",       enabled = false },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_z = {}
      }
    }
  },
  {
    "snacks.nvim",
    opts = {
      input = { enabled = false },
      words = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      picker = {
        patterns = {
          -- default
          ".git",
          "_darcs",
          ".hg",
          ".bzr",
          ".svn",
          "package.json",
          "Makefile",
          -- custom
          ".obsidian"
        }
      },
      dashboard = {
        preset = {
          header = "",
          keys = {
            { icon = "🖿 ", key = "e", desc = "Browse Files", action = ':Neotree' },
            { icon = " ", key = "p", desc = "Projects", action = ':lua Snacks.picker.projects()', },
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          }
        }
      }
    }
  },
  {
    "ahmedkhalf/project.nvim",
    opts = {
      -- All the patterns used to detect root dir, when **"pattern"** is in
      -- detection_methods
      patterns = {
        -- default
        ".git",
        "_darcs",
        ".hg",
        ".bzr",
        ".svn",
        "Makefile",
        "package.json",
        -- custom
        ".obsidian"
      },
    },
    event = "VeryLazy",
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      document_highlight = { enabled = false },
      inlay_hints = { enabled = false, }
    },
  },
  {
    "echasnovski/mini.snippets",
    opts = function(_, opts)
      local snippets = require("mini.snippets")
      local config_path = vim.fn.stdpath("config")

      opts.snippets = { -- override opts.snippets provided by extra...
        -- Load custom file with global snippets first (order matters)
        snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),

        -- Load snippets based on current language by reading files from
        -- "snippets/" subdirectories from 'runtimepath' directories.
        snippets.gen_loader.from_lang(), -- this is the default in the extra...
      }
    end,
  },
}
