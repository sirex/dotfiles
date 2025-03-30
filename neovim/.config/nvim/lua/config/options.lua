-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here


-- LazyVim root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = {
  "lsp",
  {
    ".git",
    ".obsidina",
    "lua"
  },
  "cwd"
}

-- Do not highligh search term
vim.opt.hlsearch = false

vim.opt.spelllang = { "lt", "en" }

vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.smoothscroll = false
