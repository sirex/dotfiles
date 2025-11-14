require("custom.options")
require("custom.keymaps")
require("custom.autocmds")
local lazy = require("custom.lazy")

--  Load plugins from `lua/custom/plugins/*.lua`.
require("lazy").setup({ { import = "custom.plugins" } }, lazy)
