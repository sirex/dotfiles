--------------------------------------------------------------------
-- Options

local o = vim.opt

o.clipboard = "unnamedplus"
o.fileencoding = "utf-8"
o.hlsearch = false
o.ignorecase = true
o.smartcase = true
o.smartindent = true
o.mouse = "a"
o.termguicolors = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.number = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 4
o.sidescrolloff = 8
o.backup = false
o.swapfile = false
o.undofile = true
o.writebackup = false
o.background = "dark"
o.spell = false
o.spelllang = { "lt", "en" }
o.completeopt = { "menu", "menuone", "noselect" }
o.wildignore = { "*.pyc", "__pycache__" }
o.cmdheight = 1
o.laststatus = 3
o.guicursor = {"a:blinkon1"}

vim.cmd [[
try
  colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme desert
endtry
]]


--------------------------------------------------------------------
-- Environment

vim.env.SSH_AUTH_SOCK = vim.env.XDG_RUNTIME_DIR .. "/ssh-agent.socket"


---------------------------------------------------------------------
-- Keymaps

local function map(mode, lhs, rhs, opts)
    opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

--Remap space as leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Go to settings
map('n', '<leader>gs',  ":edit ~/dotfiles/neovim/.config/nvim/init.lua<cr>")

-- Got to previous file
map("n", "<C-Tab>", "<C-6>")

-- Go to the beginning of line
map("n", "<SPACE>", "^")

-- Replace selected text without loosing " buffer value
map("v", "p", '"_dP')

-- Save file if changed
map("n", "<C-s>", ":update<CR>")

-- Scroll half page up/down
map("n", "<C-j>", "<c-d>")
map("n", "<C-k>", "<c-u>")

-- Better window navigation
map("n", "<TAB>", "<C-W>p")
map("n", "<A-h>", "<C-w>h")
map("n", "<A-j>", "<C-w>j")
map("n", "<A-k>", "<C-w>k")
map("n", "<A-l>", "<C-w>l")

-- Better window resizing
map("n", "<C-Up>",    ":resize -2<CR>")
map("n", "<C-Down>",  ":resize +2<CR>")
map("n", "<C-Left>",  ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Move text up and down
map("v", "<A-j>", ":move .+1<CR>==")
map("v", "<A-k>", ":move .-2<CR>==")
map("x", "<A-j>", ":move '>+1<CR>gv-gv")
map("x", "<A-k>", ":move '<-2<CR>gv-gv")

-- Lua related mappings
map("v", "<leader>ls", ":'<lt>,'>source<cr>")    -- execute selected lua code


function _G.gotofile_on_prev_window()
    local line = vim.api.nvim_get_current_line()
    local fname, lnum = nil, nil
    local patterns = {
        'File "([^"]+)", line (%d+)',
        '([%w_/.-]+):(%d+)',
    }
    for i = 1, #patterns do
        local pat = patterns[i]
        fname, lnum = line:match(pat)
        if fname then
            break
        end
    end

    if fname then
        vim.cmd('wincmd p')
        vim.cmd('edit ' .. fname)
        vim.cmd('norm ' .. lnum .. 'gg')
    end
end
map('n', '<leader>gf', '<cmd>lua gotofile_on_prev_window()<cr>')

-- pdb
local function pyword(line, col)
    local lhs = line:sub(1, col):reverse():match('[%a%d_.]+'):reverse()
    local rhs = line:sub(col):match('[%a%d_]+')
    return lhs .. rhs:sub(2)
end
assert(pyword('   a = self.word: # comment', 14) == 'self.word')
assert(pyword('   a = self.word: # comment', 9) == 'self')
assert(pyword('   a = self.word: # comment', 4) == 'a')
function _G._pdb_breakpoint()
    local file = vim.fn.expand('%')
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    vim.cmd('T b ' .. file .. ':' .. row)
end
function _G._pdb_pp()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local word = pyword(line, col)
    vim.cmd('T pp ' .. word)
end
map('n', '<leader>db',  '<cmd>lua _pdb_breakpoint()<CR>')
map('n', '<leader>dc',  '<cmd>T c<CR>')
map('n', '<leader>do',  '<cmd>T n<CR>')
map('n', '<leader>di',  '<cmd>T s<CR>')
map('n', '<leader>dl',  '<cmd>T l<CR>')
map('n', '<leader>dp',  '<cmd>lua _pdb_pp()<CR>')
map('n', '<leader>dq',  '<cmd>T q<CR>')


---------------------------------------------------------------------
-- Helpers


local function install_packer()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        PACKER_BOOTSTRAP = fn.system {
            "git", "clone", "--depth", "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        }
        print "Installing packer close and reopen Neovim..."
        vim.cmd [[packadd packer.nvim]]
    end
end


local function load(module_name)
    local ok, module = pcall(require, module_name)
    if ok then
        return module
    else
        return nil
    end
end


---------------------------------------------------------------------
-- Plugins

-- Automatically install packer
install_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    " autocmd BufWritePost init.lua source <afile> | PackerSync
    autocmd BufWritePost init.lua source <afile>
  augroup end
]]

local packer = load "packer"
if packer then
    -- Have packer use a popup window
    packer.init {
        display = {
            open_fn = function()
                return require("packer.util").float { border = "rounded" }
            end,
        },

    }

    packer.startup(function(use)
        -- Have packer manage itself
        use "wbthomason/packer.nvim"

        -- An implementation of the Popup API from vim in Neovim
        use "nvim-lua/popup.nvim"

        -- Useful lua functions used by lots of plugins
        use "nvim-lua/plenary.nvim"

        -- Autopairs, integrates with both cmp and treesitter
        use "windwp/nvim-autopairs"
        use "kyazdani42/nvim-web-devicons"

        -- Colorschemes
        use "jnurmine/Zenburn"
        use "lunarvim/darkplus.nvim"
        use 'mjlbach/onedark.nvim'
        use 'folke/tokyonight.nvim'
        use 'arcticicestudio/nord-vim'

        -- The completion plugin
        use "hrsh7th/cmp-nvim-lsp"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "hrsh7th/cmp-cmdline"
        use "saadparwaiz1/cmp_luasnip"

        -- snippet engine
        use "L3MON4D3/LuaSnip"

        -- a bunch of snippets to use
        use "rafamadriz/friendly-snippets"

        -- LSP
        -- enable LSP
        use "neovim/nvim-lspconfig"
        use "tamago324/nlsp-settings.nvim"
        use "williamboman/nvim-lsp-installer"

        --  debugger
        use 'mfussenegger/nvim-dap'

        -- for formatters and linters
        -- use "jose-elias-alvarez/null-ls.nvim"

        -- Telescope
        use "nvim-telescope/telescope.nvim"

        -- Treesitter
        use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
        -- use "JoosepAlviste/nvim-ts-context-commentstring"

        -- Git
        use "tpope/vim-fugitive"
        use "lewis6991/gitsigns.nvim"
        -- use "TimUntersberger/neogit"

        -- NERDTree
        use "preservim/nerdtree"

        use "kassio/neoterm"

        use "aklt/plantuml-syntax"

        use 'hkupty/iron.nvim'

        -- Automatically set up your configuration after cloning packer.nvim
        if PACKER_BOOTSTRAP then
            require("packer").sync()
        end
    end)
end



---------------------------------------------------------------------
-- treesitter

local treesitter = load "nvim-treesitter.configs"

if treesitter then
    treesitter.setup {
        ensure_installed = "all",
        -- install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- List of parsers to ignore installing
        ignore_install = { "" },
        autopairs = {
            enable = true,
        },
        highlight = {
            enable = true,
            -- list of language that will be disabled
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = true,
        },
        indent = {
            enable = false,
            disable = {"yaml"}
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    }
end


---------------------------------------------------------------------
-- nvim-cmp

local cmp = load "cmp"
local luasnip = load "luasnip"

if cmp and luasnip then
    local has_words_before = function()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        if col == 0 then
            return false
        else
            local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
            return line:sub(col, col):match("%s") == nil
        end
    end

    cmp.setup {
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        completion = {
            autocomplete = false,
        },
        mapping = {
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
            ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
            ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources(
            {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
            {
                { name = 'buffer' },
            }
        )
    }

    local s = luasnip.snippet
    local p = require("luasnip.extras").partial
    local t = luasnip.text_node
    luasnip.add_snippets(nil, {
        all = {
            s("today", p(os.date, "%Y-%m-%d")),
            s("now", p(os.date, "%Y-%m-%d %H:%M")),
            s("bp", t("breakpoint()")),
        },
    })

end


---------------------------------------------------------------------
-- lsp


local lspconfig = load "lspconfig"
local lspinstaller = load "nvim-lsp-installer"
local nlspsettings = load "nlspsettings"
local cmp_nvim_lsp = load "cmp_nvim_lsp"

-- Usage:
--
--   :LspSettings local pylsp
--   :e .nlsp-settings/pylsp.json
--   {
--       "pylsp.plugins.jedi.environment": "/home/sirex/.cache/pypoetry/virtualenvs/vitrina-dJ5t4DVf-py3.10"
--   }
--   :w
--   :LspSettings update pylsp
--

if nlspsettings then
    -- https://github.com/tamago324/nlsp-settings.nvim
    -- :LspSettings local pylsp
    nlspsettings.setup({
      config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
      local_settings_dir = ".nlsp-settings",
      local_settings_root_markers_fallback = { '.git' },
      append_default_schemas = true,
      loader = 'json',
    })
end

if lspconfig and lspinstaller then

    map('n', '<leader>de',    '<cmd>lua vim.diagnostic.open_float()<CR>')
    map('n', '[d',          '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    map('n', ']d',          '<cmd>lua vim.diagnostic.goto_next()<CR>')
    map('n', '<leader>da',    '<cmd>lua vim.diagnostic.setloclist()<CR>')

    local function on_attach(client, bufnr)
        local function _map(mode, lhs, rhs)
            local opts = { noremap = true, silent = true }
            vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end

        _map('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>')
        _map('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>')
        _map('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>')
        _map('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>')
        _map('n', 'gs',         '<cmd>lua vim.lsp.buf.signature_help()<CR>')
        _map('n', '<leader>wa',  '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
        _map('n', '<leader>wr',  '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
        _map('n', '<leader>wl',  '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
        _map('n', '<leader>D',   '<cmd>lua vim.lsp.buf.type_definition()<CR>')
        _map('n', '<leader>r',  '<cmd>lua vim.lsp.buf.rename()<CR>')
        _map('n', '<leader>ca',  '<cmd>lua vim.lsp.buf.code_action()<CR>')
        _map('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>')
        _map('n', '<leader>f',   '<cmd>lua vim.lsp.buf.formatting()<CR>')

        vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            vim.api.nvim_exec([[
                augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
                augroup END
            ]], false)
        end
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if cmp_nvim_lsp then
        capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
    end

    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn",  text = "" },
        { name = "DiagnosticSignHint",  text = "" },
        { name = "DiagnosticSignInfo",  text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            texthl = sign.name,
            text = sign.text,
            numhl = ""
        })
    end

    vim.diagnostic.config {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    local servers = {}

    -------------------------------------------------------
    -- lua
    -- Make runtime files discoverable to the server
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    servers.sumneko_lua = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're
                    -- using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file('', true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    }

    -------------------------------------------------------
    -- pylsp
    -- https://github.com/williamboman/nvim-lsp-installer/blob/main/lua/nvim-lsp-installer/servers/pylsp/README.md
    -- :PylspInstall pyls-flake8 pylsp-mypy pyls-isort

    -------------------------------------------------------
    -- jedi_language_server

    lspinstaller.on_server_ready(function(server)
        local opts = {
            capabilities = capabilities,
            on_attach = on_attach,
            flags = {
                -- This will be the default in neovim 0.7+
                debounce_text_changes = 150,
            }
        }

        if servers[server.name] then
            opts = vim.tbl_deep_extend("force", servers[server.name], opts)
        end

        server:setup(opts)
    end)
end


---------------------------------------------------------------------
-- nvim-dap


-- local dap = load "dap"
-- 
-- if dap then
-- 
--     map('n', '<leader>db',  '<cmd>lua dap.toggle_breakpoint()<CR>')
--     map('n', '<leader>dc',  '<cmd>lua dap.continue()<CR>')
--     map('n', '<leader>do',  '<cmd>lua dap.step_over()<CR>')
--     map('n', '<leader>di',  '<cmd>lua dap.step_into()<CR>')
--     map('n', '<leader>dr',  '<cmd>lua dap.repl.open()<CR>')
-- 
--     dap.adapters.python = {
--       type = 'executable';
--       command = '.venv/bin/python';
--       args = { '-m', 'debugpy.adapter' };
--     }
-- 
-- end


---------------------------------------------------------------------
-- Telescope

local telescope = load "telescope"

if telescope then
    map('n', '<leader>fa',  "<cmd>Telescope<cr>")
    map('n', '<leader>ff',  "<cmd>lua require('telescope.builtin').find_files()<cr>")
    map('n', '<C-N>',       "<cmd>lua require('telescope.builtin').find_files()<cr>")
    map('n', '<leader>vs',  "<cmd>lua require('telescope.builtin').git_status()<cr>")
    map('n', '<leader>fc',  "<cmd>lua require('telescope.builtin').command_history()<cr>")
    map('n', '<leader>fj',  "<cmd>lua require('telescope.builtin').jumplist()<cr>")
    map('n', '<leader>fk',  "<cmd>lua require('telescope.builtin').keymaps()<cr>")
    map('n', '<leader>fg',  "<cmd>lua require('telescope.builtin').live_grep()<cr>")
    map('n', '<leader>fb',  "<cmd>lua require('telescope.builtin').buffers()<cr>")
    map('n', '<C-e>',       "<cmd>lua require('telescope.builtin').buffers()<cr>")
    map('n', '<leader>fh',  "<cmd>lua require('telescope.builtin').help_tags()<cr>")
    map('n', '<leader>fo',  "<cmd>lua require('telescope.builtin').oldfiles()<cr>")
    map('n', '<leader>fm',  "<cmd>lua require('telescope.builtin').man_pages()<cr>")
    map('n', '<leader>fw',  "<cmd>lua require('telescope.builtin').grep_string()<cr>")

    if lspconfig then
        map('n', '<leader>fr',  "<cmd>lua require('telescope.builtin').lsp_references()<cr>")
    end

    local actions = require "telescope.actions"

    telescope.setup {
        defaults = {
            -- ~/.local/share/nvim/site/pack/packer/start/telescope.nvim/lua/telescope/mappings.lua
            mappings = {
                i = {
                    ["<A-j>"] = actions.move_selection_next,
                    ["<A-k>"] = actions.move_selection_previous,
                },
            }
        },
        pickers = {
            find_files = {
                previewer = false,
            },
            buffers = {
                previewer = false,
                sort_mru = true,
            }
        },
    }
end


---------------------------------------------------------------------
-- NERDTree

map('n', '<A-1>', '<cmd>NERDTreeToggle<cr>')
map('n', '<leader>nf', '<cmd>NERDTreeFind<cr>')
-- vim.g.NERDTreeMapCustomOpen = 'h'
-- vim.g.NERDTreeMapActivateNode = 'l'
vim.g.NERDTreeMapPreview = 'o'
vim.g.NERDTreeRespectWildIgnore = 1
vim.g.NERDTreeWinSize = 30
vim.g.NERDTreeWinPos = 'right'
vim.g.NERDTreeIgnore = {
    '^__pycache__$',
    '\\.egg-info$',
    '\\~$',
    '\\.pyc$'
}


---------------------------------------------------------------------
-- GitSigns

local gitsigns = load "gitsigns"

if gitsigns then
    gitsigns.setup {
        on_attach = function(bufnr)
            local function _map(mode, lhs, rhs, opts)
                opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
                vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
            end

            -- Navigation
            _map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
            _map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

            -- Actions
            _map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>')
            _map('v', '<leader>hs', ':Gitsigns stage_hunk<CR>')
            _map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>')
            _map('v', '<leader>hr', ':Gitsigns reset_hunk<CR>')
            _map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
            _map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
            _map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
            _map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')
            _map('n', '<leader>hb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
            _map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
            _map('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>')
            _map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')
            _map('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>')

            -- Text object
            _map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            _map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
end


---------------------------------------------------------------------
-- Neogit

-- local neogit = load "neogit"
-- 
-- if neogit then
--     map('n', '<A-2>', '<cmd>Neogit<cr>')
-- 
--     neogit.setup {
--         mappings = {
--             status = {
--                 ["<A-2>"] = "Close",
--             }
--         }
--     }
-- end

---------------------------------------------------------------------
-- Fugitive

map('n', '<A-2>', '<cmd>Git<cr>')


---------------------------------------------------------------------
-- term

vim.cmd [[
    augroup neovim_terminal
        autocmd!
        " Disables number lines on terminal buffers
        autocmd TermOpen * :setlocal nonumber norelativenumber
    augroup END
]]


---------------------------------------------------------------------
-- neoterm

function _G.neoterm_run()
    local cmd = {}
    local line = vim.api.nvim_get_current_line()

    if line:sub(1, 2) == '$ ' then
        table.insert(cmd, line:sub(3))
    else
        return
    end

    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local num_lines = vim.api.nvim_buf_line_count(0)
    for _, line in pairs(vim.api.nvim_buf_get_lines(0, row, num_lines, true)) do
        if line:sub(1, 2) == '  ' or vim.trim(line) == '' then
            --cmd = cmd .. '\n' .. line:sub(3)
            table.insert(cmd, line:sub(3))
        elseif vim.trim(line) == '' then
            --cmd = cmd .. '\n'
            table.insert(cmd, '')
        else
            break
        end
    end

    local term
    if vim.v.count > 0 then
        term = vim.v.count
    else
        term = ''
    end

    -- vim.cmd(term .. "Texec " .. cmd)
    -- vim.cmd(term .. "Texec " .. cmd .. '\n')
    vim.fn['g:neoterm.repl.exec'](cmd)
    vim.call('neoterm.repl.exec', { 'ls -l' })
    print(vim.inspect(vim.g.neoterm.repl))
    -- call g:neoterm.repl.exec(l:lines)
    --
    -- 2022-03-27 12:08
    -- vim.fn.chansend(vim.b.terminal_job_id, "print('ok')")
    -- nvim_list_wins() does not work, don't know why
end



map('n', '<M-e>', '<cmd>lua neoterm_run()<cr>')
vim.g.neoterm_size = 15
vim.g.neoterm_default_mod = 'botright'
vim.g.neoterm_auto_repl_cmd = 0
vim.g.neoterm_shell = "zsh"
vim.g.neoterm_autoinsert = 0
vim.g.neoterm_autoscroll = 1
map('n', '<F12>', '<cmd>Ttoggle botright<cr>')
map('t', '<Esc>', '<C-\\><C-N>')
map('t', '<A-h>', '<C-\\><C-N><C-w>h')
map('t', '<A-j>', '<C-\\><C-N><C-w>j')
map('t', '<A-k>', '<C-\\><C-N><C-w>k')
map('t', '<A-l>', '<C-\\><C-N><C-w>l')
-- map('n', 'gt',    '<Plug>(neoterm-repl-send-line)')
-- map('v', 'gt',    '<Plug>(neoterm-repl-send)')
-- map('n', 'tl', '<Plug>(neoterm-repl-send-line)')
vim.cmd('nmap gt <Plug>(neoterm-repl-send-line)')
vim.cmd('vmap gt <Plug>(neoterm-repl-send)')

-- nmap    gt          <Plug>(neoterm-repl-send)
-- xmap    gt          <Plug>(neoterm-repl-send)
-- nmap    gtt         <Plug>(neoterm-repl-send-line)


---------------------------------------------------------------------
-- iron

-- local iron = load "iron.core"
-- 
-- if iron then
--     iron.setup {
--         config = {
--             buflisted = true,
--         },
--         -- Iron doesn't set keymaps by default anymore. Set them here
--         -- or use `should_map_plug = true` and map from you vim files
--         keymaps = {
--             send_motion = "<leader>sc",
--             visual_send = "<leader>sc",
--             send_line = "<leader>sl",
--             repeat_cmd = "<leader>s.",
--             cr = "<leader>s<cr>",
--             interrupt = "<leader>s<space>",
--             exit = "<leader>sq",
--             clear = "<leader>cl",
--         }
--     }
-- end
