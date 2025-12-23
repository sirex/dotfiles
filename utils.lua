-- vim: set shiftwidth=2 tabstop=2 expandtab:

local M = {}

-- Toggle Term

function M.set_term_cmd()
	local cmd = vim.api.nvim_get_current_line()
	if cmd ~= "" then
		vim.g.last_terminal_command = cmd
	end
end

function M.run_term_cmd()
	local cmd = vim.g.last_terminal_command
	if cmd and cmd ~= "" then
		require("toggleterm").exec(cmd)
	end
end

-- Telescope

function M.projects()
	require("telescope").extensions.projects.projects({})
end

function M.mru()
	require("telescope.builtin").buffers({
		sort_mru = true,
		sort_lastused = true,
		ignore_current_buffer = true,
	})
end

-- Obsidian

function M.note_id(title)
	local suffix = ""
	if title ~= nil then
		return title
	else
		for _ = 1, 4 do
			suffix = suffix .. string.char(math.random(65, 90))
		end
		return tostring(os.time()) .. "_" .. suffix
	end
end

function M.follow_url(url)
	vim.fn.jobstart({ "xdg-open", url })
end

function M.follow_img(img)
	vim.fn.jobstart({ "xdg-open", img })
end

function M.img_name()
	return string.format("IMG_%s.png", os.date("%Y%m%d_%H%M%S"))
end

return M
