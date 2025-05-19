return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<leader>e", ":NvimTreeToggle<CR>", desc = "NvimTreeToggle", silent = true },
  },
  opts = {
    filters = {
      dotfiles = false,
    },
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      width = 30,
      preserve_window_proportions = true,
    },
    renderer = {
      root_folder_label = false,
      highlight_git = true,
      indent_markers = { enable = true },
      icons = {
        glyphs = {
          default = "󰈚",
          folder = {
            default = "",
            empty = "",
            empty_open = "",
            open = "",
            symlink = "",
          },
          git = { unmerged = "" },
        },
      },
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        })
      end

      -- default mappings
      -- https://github.com/nvim-tree/nvim-tree.lua/blob/44d9b58f11d5a426c297aafd0be1c9d45617a849/doc/nvim-tree-lua.txt#L2470
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      map("<C-d>", api.tree.change_root_to_node, "CD")
      map("u", api.tree.change_root_to_parent, "Up")
      map("h", api.node.navigate.parent_close, "Close Directory")
      map("l", api.node.open.edit, "Open")
      map("?", api.tree.toggle_help, "Help")
      map("<Tab>", "<C-W>p", "Swich to previous window")
    end,
  },
}
