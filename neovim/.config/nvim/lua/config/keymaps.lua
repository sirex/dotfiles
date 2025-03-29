-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- https://neovim.io/doc/user/lua.html#vim.keymap.set()
local map = vim.keymap.set

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>up<cr><esc>", { desc = "Save File" })

-- Page serolling
map("n", "<A-k>", "<c-u>", { desc = "Half page up" })
map("n", "<A-j>", "<c-d>", { desc = "Half page down" })

-- Window navigation
map("n", "<C-k>", "<C-w>k", { desc = "Switch to top window" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch to bottom window" })
map("n", "<C-h>", "<C-w>h", { desc = "Switch to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch to right window" })
map("n", "<TAB>", "<C-W>p", { desc = "Switch to last window" })

-- Buffer navigation
map("n", "<C-Tab>", "<C-6>", { desc = "Switch to last buffer" })

-- Terminal Mappings
map("t", "<C-Enter>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("n", "<c-Enter>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })


vim.keymap.del("v", "<")
vim.keymap.del("v", ">")
