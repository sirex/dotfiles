-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- If this is  enabled, picker <esc> stops working
-- vim.api.nvim_create_autocmd({ "TermOpen" }, {
--   group = augroup("terminal"),
--   pattern = "term://*",
--   callback = function(event)
--     vim.keymap.set("t", "<esc>", "<c-\\><c-n>", {
--       desc = "Enter Normal Mode",
--       buffer = event.buf,
--       nowait = true
--     })
--   end,
-- })
