local repl = {
  ["ą"] = "a",
  ["č"] = "c",
  ["ę"] = "e",
  ["ė"] = "e",
  ["į"] = "i",
  ["š"] = "s",
  ["Į"] = "I",
  ["ų"] = "u",
  ["ū"] = "u",
  ["ž"] = "z",
  ["Ą"] = "A",
  ["Č"] = "C",
  ["Ę"] = "E",
  ["Ė"] = "E",
  ["Š"] = "S",
  ["Ų"] = "U",
  ["Ū"] = "U",
  ["Ž"] = "Z",
}
---@param input string
---@return string
local function unidecode(input)
  return (input:gsub("[%z\1-\127\194-\244][\128-\191]*", repl))
end

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
    return (unidecode(title):gsub("[^A-Za-z0-9_-]", ""))
  else
    return random_id()
  end
end

-- https://github.com/epwalsh/obsidian.nvim
return {
  "epwalsh/obsidian.nvim",
  ft = "markdown",
  keys = {
    { "<leader>oo", "<cmd>ObsidianToday<cr>", desc = "Obsidian daily note" },
    { "<leader>op", "<cmd>ObsidianToday -1<cr>", desc = "Obsidian daily note (previous day)" },
    { "<leader>oy", "<cmd>ObsidianYesterday<cr>", desc = "Obsidian daily note (previous work day)" },
    { "<leader>or", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian backlinks" },
    { "<leader>oi", "<cmd>ObsidianPasteImg<cr>", desc = "Obsidian passte image from clipboard" },
    { "<leader>ot", "<cmd>ObsidianTOC<cr>", desc = "Obsidian table of content" },
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
    },

    -- Optional, customize how note IDs are generated given an optional title.
    note_id_func = node_id_func,

    -- `:ObsidianFollowLink` on a link to an external URL
    ---@param url string
    follow_url_func = function(url)
      vim.fn.jobstart({ "xdg-open", url }) -- Linux
    end,
    ui = {
      enable = false,
    },
  },
}
