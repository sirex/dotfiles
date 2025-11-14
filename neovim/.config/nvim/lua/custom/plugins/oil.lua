return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Oil: File browser" },
  },
  opts = {
    keymaps = {
      ["<C-CR>"] = { "actions.select", opts = { horizontal = true } },
      ["<S-CR>"] = { "actions.select", opts = { vertical = true } },
      ["<C-r>"] = "actions.refresh",

      -- Restore global keymaps
      ["<C-s>"] = "<CMD>write<CR>",
      ["<C-h>"] = "<C-w><C-h>",
      ["<C-l>"] = "<C-w><C-l>",
    },
    delete_to_trash = true,
  },
  -- Optional dependencies
  dependencies = {
    { "echasnovski/mini.icons", opts = {} },
  },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
