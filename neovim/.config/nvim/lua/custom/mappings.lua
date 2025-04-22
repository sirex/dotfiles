-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Do not highligh search term
vim.opt.hlsearch = false

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<Tab>", "<C-W>p", { desc = "Swich to previous window" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w><C-h>", { desc = "Move focus to the left window from terminal" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w><C-l>", { desc = "Move focus to the right window from terminal" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w><C-j>", { desc = "Move focus to the lower window from terminal" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w><C-k>", { desc = "Move focus to the upper window from terminal" })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Save file
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>up<cr><esc>", { desc = "Save File" })

-- Buffer navigation
vim.keymap.set("n", "<C-Tab>", "<C-6>", { desc = "Switch to last buffer" })

-- Page serolling
vim.keymap.set("n", "<A-k>", "<c-u>", { desc = "Half page up" })
vim.keymap.set("n", "<A-j>", "<c-d>", { desc = "Half page down" })

-- Open terminal
-- vim.keymap.set("n", "<C-Enter>", ":split | terminal<CR>")

-- Set options
vim.keymap.set("n", "<leader>sc", function()
  if vim.o.conceallevel == 0 then
    vim.o.conceallevel = 2
  else
    vim.o.conceallevel = 0
  end
end, { desc = "Toggle conceallevel 0 <-> 2" })
vim.keymap.set("n", "<leader>ss", function()
  vim.o.spell = not vim.o.spell
end, { desc = "Toggle spell" })
vim.keymap.set("n", "<leader>st", function()
  vim.o.expandtab = not vim.o.expandtab
end, { desc = "Toggle tabs" })

-- Lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Neovim
vim.keymap.set("n", "<leader>vs", "<cmd>source %<cr>", { desc = ":source %" })
