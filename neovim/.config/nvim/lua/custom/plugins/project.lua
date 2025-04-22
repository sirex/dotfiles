-- https://github.com/ahmedkhalf/project.nvim/issues/123#issuecomment-1817851586
local function picker()
  require("telescope").extensions.projects.projects({})
end

return {
  "ahmedkhalf/project.nvim",
  lazy = false,
  main = "project_nvim",
  keys = {
    { "<leader>fp", picker, desc = "[F]ind a [P]project" },
    { "<leader>sr", "<cmd>ProjectRoot<cr>", desc = "[S]et Project [R]oot" },
  },
  opts = {
    manual_mode = true,
    patterns = {
      ".git",
      ".obsidian",
      "lua",
      "Makefile",
      "package.json",
    },
  },
}
