-- vim: set shiftwidth=2 tabstop=2 expandtab:

local M = {}

-- Toggle Term

function _get_term_name(term)
    return string.format("%d: %s", term.id, term:_display_name())
end

function _get_term_id(callback)
  local all_terms = require("toggleterm.terminal").get_all()
  local open_terms = {}

  for _, term in pairs(all_terms) do
    if term:is_open() then
      table.insert(open_terms, term)
    end
  end

  if #open_terms == 1 then
    callback(open_terms[1].id)
  elseif #open_terms > 1 then
    vim.ui.select(open_terms, {
      prompt = "Select terminal: ",
      format_item = _get_term_name
    }, function(choice) 
        if choice then callback(choice.id) end 
      end)
  elseif #all_terms == 1 then
    callback(all_terms[1].id)
  elseif #all_terms > 1 then
    vim.ui.select(all_terms, {
      prompt = "Select terminal: ",
      format_item = _get_term_name
    }, function(choice) 
        if choice then callback(choice.id) end 
      end)
  else
    callback(1)
  end
end

function _term_close_others(target_id)
  if target_id then
    local terminals = require("toggleterm.terminal").get_all()
    for _, term in pairs(terminals) do
      if term.id ~= target_id and term:is_open() then
        term:close()
      end
    end
  end
end

function M.term_send_lines(motion_type, opts)
  local current_win = vim.api.nvim_get_current_win()
  _get_term_id(function (id)
    if id then
      -- motion_type: single_line | visual_lines | visual_selection
      opts = vim.tbl_extend("keep", opts or {}, {
        trim_spaces = false
      })
      require("toggleterm").send_lines_to_terminal(motion_type, opts.trim_spaces, {
        args = id
      })
      if motion_type == "single_line" then
        pcall(function()
          vim.cmd("normal! j")
        end)
      end
    end
  end)
end

function M.term_set_cmd()
  local cmd = vim.api.nvim_get_current_line()
  if cmd ~= "" then
    vim.g.last_terminal_command = cmd
    _get_term_id(function (id) 
      vim.g.last_terminal_id = id
    end)
  end
end

function M.term_run_cmd()
  local cmd = vim.g.last_terminal_command
  if cmd and cmd ~= "" then
    _term_close_others(vim.g.last_terminal_id)
    require("toggleterm").exec(cmd, vim.g.last_terminal_id)
  end
end

function M.term_new()
  local current_win = vim.api.nvim_get_current_win()
  for _, term in pairs(require("toggleterm.terminal").get_all()) do
    term:close()
  end
  vim.cmd("TermNew")
  vim.api.nvim_set_current_win(current_win)
  vim.cmd("stopinsert")
end

function M.term_select()
  local current_win = vim.api.nvim_get_current_win()
  local terms = require("toggleterm.terminal").get_all()
  vim.ui.select(terms, {
    prompt = "Select terminal: ",
    format_item = _get_term_name
  }, function(term) 
    if term then 
      _term_close_others(term.id)
      if term:is_open() then
        term:focus()
      else
        term:open()
      end
      vim.api.nvim_set_current_win(current_win)
      vim.cmd("stopinsert")
    end 
  end)
end

function M.term_set_name()
  _get_term_id(function(id)
    if id then
      vim.ui.input({ prompt = "Set terminal name: " }, function(new_name)
        if not new_name or new_name == "" then 
          return
        end

        local term = require("toggleterm.terminal").get(id)
        if term then
          term.display_name = new_name
          vim.notify("Terminal " .. id .. " renamed to: " .. new_name)
        end
      end)
    end
  end)
end


-- OpenCode
local _opencode_bufs = {}  -- cwd -> bufnr

function M.opencode_open()
  local cwd = vim.fn.getcwd()
  local buf = _opencode_bufs[cwd]

  -- Reuse existing opencode buffer for this cwd if still valid.
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("startinsert")
    return
  end

  -- Otherwise spawn a fresh opencode terminal buffer in the current window.
  vim.cmd("enew")                       -- new empty buffer in current window
  vim.fn.jobstart({ "opencode" }, {
    term = true,
    cwd = cwd,
  })
  _opencode_bufs[cwd] = vim.api.nvim_get_current_buf()
  vim.cmd("startinsert")
end

function _jump_to_line(line)
  local lnum = string.match(line, "line (%d+)")
  if not lnum then
    lnum = string.match(line, ":(%d+)")
  end

  if lnum then
    local line_number = tonumber(lnum)
    pcall(vim.api.nvim_win_set_cursor, 0, { line_number, 0 })
    vim.cmd('normal! zz')
  end
end

function M.term_gf(opts)
  vim.keymap.set('n', 'gf', function()
    local file = vim.fn.expand('<cfile>')
    local line = vim.api.nvim_get_current_line()

    if file ~= "" then
      vim.cmd('wincmd p')
      vim.cmd('edit ' .. vim.fn.fnameescape(file))
      _jump_to_line(line)
    else
      vim.notify("No file under cursor", vim.log.levels.WARN)
    end
  end, { buffer = opts.buf, desc = "gf in previous window" })
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
    no_ignore = true,
    follow = true,
  })
end

function M.zoxide()
  require('telescope').extensions.zoxide.list()
end

function M.zoxide_find()
  local telescope = require("telescope")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")

  telescope.extensions.zoxide.list({
    prompt_title = "[ Pick Directory to Search ]",
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          builtin.find_files({
            cwd = selection.path,
            prompt_title = "[ Files in: " .. selection.path .. " ]",
            hidden = true,
            no_ignore = true,
            follow = true,
          })
        end
      end)
      return true
    end
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

function M.pick_octo_repo()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local repo_file = vim.fn.expand("~/.config/gh/repos")

  if vim.fn.filereadable(repo_file) == 0 then
    vim.notify("Repository file not found: " .. repo_file, vim.log.levels.WARN)
    return
  end

  local repos = vim.fn.readfile(repo_file)

  pickers.new({}, {
    prompt_title = "Select GitHub Repository",
    finder = finders.new_table { results = repos },
    sorter = conf.generic_sorter({}),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("Octo issue list " .. selection.value)
        end
      end)
      return true
    end,
  }):find()
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
function M.wiki_link_word()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('ciw[[<C-r>"]]<Esc>', true, false, true),
    'n', false
  )
end

function M.wiki_link_sel()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('c[[<C-r>"]]<Esc>', true, false, true),
    'n', false
  )
end

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

function M.toggle(option, enabled, disabled)
  local current = vim.opt_local[option]:get()
  local target
  if enabled ~= nil and disabled ~= nil then
    target = (current == enabled) and disabled or enabled
  else
    target = not current
  end
  vim.opt_local[option] = target
end


function M.dotenv()
  local env_file = os.getenv("HOME") .. "/.env"
  local f = io.open(env_file, "r")
  if f then
    for line in f:lines() do
      if not line:match("^%s*#") and line:match("=") then
        local key, value = line:match("^%s*([^=]+)%s*=%s*(.*)%s*$")
        if key and value then
          value = value:gsub("^['\"]", ""):gsub("['\"]$", "")
          vim.env[key] = value
        end
      end
    end
    f:close()
  end
end

function M.open_mini_files()
  local MiniFiles = require('mini.files')
  local buf_name = vim.api.nvim_buf_get_name(0)
  if not MiniFiles.close() then
    MiniFiles.open(buf_name)
  end
end

function M.jump()
  require("flash").jump()
end

function M.jump_treesitter()
  require("flash").treesitter()
end

function M.toggle_jump_search()
  require("flash").toggle()
end


function M.gitlinker(mode)
  require('gitlinker').get_buf_range_url(mode, {
    action_callback = require('gitlinker.actions').open_in_browser
  })
end

function M.git_commits(mode)
  require('telescope.builtin').git_commits({
    cwd = vim.fn.expand('%:p:h'),
    git_command = { "git", "log", "--no-color", "--format=%h %as: %an | %s", "--" },
  })
end


function M.restart()
  local session = vim.fn.stdpath('state') .. '/restart.vim'
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session))
  vim.cmd('restart source ' .. vim.fn.fnameescape(session))
end


function M.help()
  local ft = vim.bo.filetype
  local cword = vim.fn.expand('<cword>')

  if ft == 'markdown' then
    vim.cmd('normal! K')
  elseif ft == 'lua' then
    vim.cmd('help ' .. cword)
  else
    if next(vim.lsp.get_clients({ bufnr = 0 })) then
      vim.lsp.buf.hover()
    else
      vim.cmd('normal! K')
    end
  end

end

function M.eval_lua()
  local line = vim.api.nvim_get_current_line()
  _eval_lua(line)
end

function M.eval_lua_sel()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))
  local code = table.concat(lines, "\n")
  vim.cmd("normal! \27")
  _eval_lua(code)
end

function _eval_lua(code)
  -- Try evaluating as an expression first by prepending 'return'
  local func, err = loadstring("return " .. code)
  if not func then
      -- If it's a statement (e.g. 'local x = 1'), 'return' fails, so load normally
      func, err = loadstring(code)
  end

  if func then
      local success, result = pcall(func)
      if success and result ~= nil then
          vim.print(result)
      elseif not success then
          vim.api.nvim_err_writeln("Error: " .. tostring(result))
      end
  else
      vim.api.nvim_err_writeln("Parsing Error: " .. tostring(err))
  end
end

function M.toggle_errors()
  local current_setting = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current_setting })
end

function M.copy(what)
  local path = vim.fn.expand(what)
  vim.fn.setreg('+', path)
  print('Copied: ' .. path)
end

function M.open_yazi()
    local file = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()
    local args = { "kitty", "--detach", "-e", "yazi" }
    if file ~= "" then
        table.insert(args, file)
    end
    vim.fn.jobstart(args, { cwd = cwd })
end

return M
