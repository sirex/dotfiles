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
    previewer = false,
  })
end

function M.find(path)
  require("telescope.builtin").find_files({
    cwd = vim.fn.expand(path),
    prompt_title = "Search: " .. path,
    hidden = true,
  })
end

function M.search_dir()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")
  builtin.find_files({
    prompt_title = "Select Directory",
    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" }, 
    previewer = false,
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        local dir = selection[1]
        builtin.live_grep({
          cwd = dir,
          prompt_title = "Search " .. dir,
        })
      end)
      return true
    end,
  })
end

-- Shortcut for searching your Neovim configuration files
function M.neovim_configs()
  require("telescope.builtin").find_files({ cwd = vim.fn.expand("~/dotfiles/neovim/.config/nvim") })
end

-- Obsidian

function M.note_id(title)
  -- 1. Try to use the title if it exists
  if title ~= nil then
    -- 1. Sanitize: Remove ONLY illegal filesystem characters.
    -- We remove: / \ : * ? " < > | and newlines.
    local sanitized = title:gsub("[%c\\/%:%*%?\"<>|]+", "_")

    -- Trim leading/trailing underscores (optional cleanup)
    sanitized = sanitized:gsub("^_+", ""):gsub("_+$", "")

    -- If we still have a valid string after sanitizing, use it
    if sanitized ~= "" then
      return sanitized
    end
  end

  -- 2. Fallback: Generate random ID if title is nil, empty, or invalid
  local suffix = ""
  for _ = 1, 4 do
    -- Generate 4 random uppercase letters (ASCII 65-90)
    suffix = suffix .. string.char(math.random(65, 90))
  end

  return tostring(os.time()) .. "_" .. suffix
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

-- programs.nixvim.plugins.obsidian.settings.wiki_link_func = lua "wiki_link_func";
function M.wiki_link_func(opts)
  -- DEBUG: Print to :messages so we know it runs
  vim.print("Obsidian Link Check: ", opts) 

  -- 1. Handle "Create New" candidates (where path is just a string)
  if type(opts.path) == "string" then
    return opts.label or opts.path
  end

  -- 2. Handle Existing Notes (where path is a Table with .name)
  if opts.path and opts.path.name then
    return opts.path.name
  end
  
  -- 3. Fallback to ID or Label
  return opts.id or opts.label
end


-- Notes

 function M.create_note()
  -- 1. Define and create the directory
  local dir = vim.fn.expand("~/tmp/notes")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  -- 2. Generate filename: note-YYYY-MM-DD-HHMMSS.md
  local filename = "note-" .. os.date("%Y-%m-%d-%H%M%S") .. ".md"
  local full_path = dir .. "/" .. filename

  -- 3. Open the file
  vim.cmd.edit(full_path)
end

function M.latest_note()
  local dir = vim.fn.expand("~/tmp/notes")
  
  -- 1. Get list of all matching files (returns a Lua table)
  local files = vim.fn.glob(dir .. "/note-*.md", false, true)
  
  if #files == 0 then
    vim.notify("No scratch notes found in " .. dir, vim.log.levels.WARN)
    return
  end
  
  -- 2. Sort files (Timestamp in name ensures alphabetical = chronological)
  table.sort(files)
  
  -- 3. Get the last item (latest date) and open it
  local latest_file = files[#files]
  vim.cmd.edit(latest_file)
end


return M
