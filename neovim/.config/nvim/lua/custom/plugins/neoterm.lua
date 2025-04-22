return {
  "kassio/neoterm",
  init = function()
    vim.g.neoterm_size = 15
    vim.g.neoterm_default_mod = 'botright'
    vim.g.neoterm_auto_repl_cmd = 0
    vim.g.neoterm_shell = "zsh"
    vim.g.neoterm_autoinsert = 0
    vim.g.neoterm_autoscroll = 1
  end,
  keys = {
    { '<C-Enter>', ':Ttoggle<cr>',              desc = "Toggle terminal panel" },
    { "<C-e>",     ":TREPLSendLine<cr>j",       desc = "Send line to terminal", mode = "n" },
    -- { "<C-e>",     "<Plug>(neoterm-repl-send-line)", desc = "Send line to terminal", mode = "n" },
    { "<C-e>",     "<Plug>(neoterm-repl-send)", desc = "Send line to terminal", mode = "v" },
  },
}
