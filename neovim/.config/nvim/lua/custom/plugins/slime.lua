local function sendkeys(keys)
  return function()
    for _, key in ipairs(keys) do
      vim.fn.feedkeys(
        vim.api.nvim_replace_termcodes(key, true, false, true),
        "n"
      )
    end
  end
end

-- E5108: Error executing lua: /home/sirex/.config/nvim/lua/plugins/terminal.lua:4: Invalid 'str': Expected Lua string
-- stack traceback:
-- 	[C]: in function 'nvim_replace_termcodes'
-- 	/home/sirex/.config/nvim/lua/plugins/terminal.lua:4: in function </home/sirex/.config/nvim/lua/plugins/terminal.lua:2>

return {
  -- https://github.com/jpalardy/vim-slime/blob/main/assets/doc/targets/neovim.md
  "jpalardy/vim-slime",
  enabled = false,
  init = function()
    -- these two should be set before the plugin loads
    vim.g.slime_target = "neovim"
    vim.g.slime_no_mappings = true
    vim.g.slime_input_pid = false
    vim.g.slime_suggest_default = true
    vim.g.slime_menu_config = true
    vim.g.slime_neovim_ignore_unlisted = false
    -- g:slime_neovim_menu_order
    -- g:slime_neovim_menu_delimiter
    -- g:slime_get_jobid
  end,
  keys = {
    { "<Leader>ts", "<Plug>SlimeConfig",                      desc = "Select terminal for send keys" },
    { "<C-e>",      sendkeys({ "<Plug>SlimeLineSend", "j" }), desc = "Send line and move down" },
    { "<C-e>",      "<Plug>SlimeRegionSend",                  desc = "Send line and move down" },
  },
  opts = {},
}
