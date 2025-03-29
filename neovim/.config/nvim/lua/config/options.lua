-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here


local o = vim.opt

-- Do not highligh search term
o.hlsearch = false

o.spelllang = { "lt", "en" }

o.number = true
o.relativenumber = false

o.smoothscroll = false
