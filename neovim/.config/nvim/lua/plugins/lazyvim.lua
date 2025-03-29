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
    'neovim/nvim-lspconfig',
    opts = {
      document_highlight = { enabled = false },
      inlay_hints = { enabled = false, }
    },
  },
}
