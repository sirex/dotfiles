-- Returns something like `1744098387-HBDM`.
---@return string
local function random_id()
  local rand = ""
  for _ = 1, 4 do
    rand = rand .. string.char(math.random(65, 90))
  end
  return tostring(os.time()) .. "_" .. rand
end

---@param title string|?
---@return string
local function node_id_func(title)
  if title ~= nil then
    return title
  else
    return random_id()
  end
end

-- https://github.com/epwalsh/obsidian.nvim
return {
  "obsidian-nvim/obsidian.nvim",
  ft = "markdown",
  keys = {
    { "<leader>oo", "<cmd>Obsidian today<cr>", desc = "Obsidian daily note" },
    { "<leader>op", "<cmd>Obsidian today -1<cr>", desc = "Obsidian daily note (previous day)" },
    { "<leader>oy", "<cmd>Obsidian yesterday<cr>", desc = "Obsidian daily note (previous work day)" },
    { "<leader>or", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian backlinks" },
    { "<leader>oi", "<cmd>Obsidian paste_img<cr>", desc = "Obsidian passte image from clipboard" },
    { "<leader>ot", "<cmd>Obsidian toc<cr>", desc = "Obsidian table of content" },
    { "<leader>oe", "<cmd>Obsidian open<cr>", desc = "Open note in Obsidian app" },
  },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {

    workspaces = {
      { name = "personal", path = "~/notes" },
      { name = "work", path = "~/ivpk/notes" },
    },
    daily_notes = {
      folder = "timelog",
      date_format = "%Y/%Y-%m-%d",
      alias_format = "%Y-%m-%d",
    },
    -- Where to put new notes. Valid options are
    --  * "current_dir" - put new notes in same directory as the current buffer.
    --  * "notes_subdir" - put new notes in the default notes subdirectory.
    new_notes_location = "current_dir",
    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",
    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "files", -- This is the default
      img_name_func = function()
        return string.format("IMG_%s.png", os.date("%Y%m%d_%H%M%S"))
      end,
      confirm_img_paste = false,
    },

    -- Optional, customize how note IDs are generated given an optional title.
    note_id_func = node_id_func,
    wiki_link_func = "use_alias_only",

    -- `:ObsidianFollowLink` on a link to an external URL
    ---@param url string
    follow_url_func = function(url)
      vim.fn.jobstart({ "xdg-open", url }) -- Linux
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
    -- file it will be ignored but you can customize this behavior here.
    ---@param img string
    follow_img_func = function(img)
      vim.fn.jobstart({ "xdg-open", img }) -- linux
    end,

    ui = {
      enable = false,
    },

    -- Do not show warnings to change `:ObsidianBacklinks` to `:Obsidian backlings`.
    legacy_commands = false,
  },
}
