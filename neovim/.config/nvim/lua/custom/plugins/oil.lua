return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  keys = {
    { "<leader>-", "<CMD>Oil<CR>", desc = "Oil: File browser" },
  },
  opts = {},
  -- Optional dependencies
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
