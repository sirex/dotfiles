local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

-------------
-- Helpers

local function run(cmd)
  local handle, err = io.popen("uuidgen")

  if not handle then
    print("Error executing `" .. cmd .. "` command: " .. err)
    return nil
  end

  local result = handle:read("*a")
  handle:close()
  return result
end

--------------
-- Snippets

local function date()
  return os.date("%Y-%m-%d")
end

local function time()
  return os.date("%H:%M")
end

local function uuid()
  return run("uuidgen"):gsub("\n", "")
end

ls.add_snippets("all", {
  s("date", f(date)),
  s("time", f(time)),
  s("uuid", f(uuid)),
})
