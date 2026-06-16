local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node

-------------
-- Helpers

local function run(cmd)
  local handle, err = io.popen(cmd)

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
  -- Ensure 'uuidgen' is available in your path!
  return run("uuidgen"):gsub("\n", "")
end

--------------
-- Register

ls.add_snippets("all", {
  s("date", f(date)),
  s("time", f(time)),
  s("uuid", f(uuid)),
  s("table", {
    t({
      "|       |       |       |",
      "|-------|-------|-------|",
      "|       |       |       |",
    }),
  }),
  s("dsa", {
    t({
      "d | r | b | m | property     | type    | ref     | level | access",
      "datasets/gov/rc/ar/uapi/addr |         |         |       |",
      "  |   |   | Country          |         | id      | 4     |",
      "  |   |   |   | id           | integer |         | 4     |",
      "  |   |   |   | code         | string  |         | 4     |",
      "  |   |   |   | name@lt      | string  |         | 4     |",
      "  |   |   | City             |         | id      | 4     |",
      "  |   |   |   | id           | integer |         | 4     |",
      "  |   |   |   | name@lt      | string  |         | 4     |",
      "  |   |   |   | country      | ref     | Country | 4     |",
    }),
  }),
  s("sdsa", {
    t({
      "d | r | b | m | property     | type    | ref     | source     | prepare | level | access",
      "datasets/gov/rc/ar/uapi/addr |         |         |            |         |       |",
      "                             | prefix  | dct     |            |         |       |",
      "                             |         | dcat    |            |         |       |",
      "                             |         | foaf    |            |         |       |",
      "                             |         | rdfs    |            |         |       |",
      "                             |         | skos    |            |         |       |",
      "                             |         | cv      |            |         |       |",
      "  | resource1                | sql     |         |            |         |       |",
      "  |   |   | Country          |         | id      | COUNTRIES  |         |       |",
      "  |   |   |   | id           | integer |         | ID         |         |       |",
      "  |   |   |   | code         | string  |         | CODE       |         |       |",
      "  |   |   |   | name@lt      | string  |         | NAME       |         |       |",
      "  |   |   | City             |         | id      | COUNTRIES  |         |       |",
      "  |   |   |   | id           | integer |         | ID         |         |       |",
      "  |   |   |   | name@lt      | string  |         | NAME       |         |       |",
      "  |   |   |   | country      | ref     | Country | COUNTRY_ID |         |       |",
    }),
  }),
  s("kdsa", {
    t({
      "d | r | b | m | property     | type    | ref     | uri",
      "datasets/gov/rc/ar/uapi/addr |         |         |",
      "                             | prefix  | dct     | http://purl.org/dc/terms/",
      "                             |         | dcat    | http://www.w3.org/ns/dcat#",
      "                             |         | foaf    | http://xmlns.com/foaf/0.1/",
      "                             |         | rdfs    | http://www.w3.org/2000/01/rdf-schema#",
      "                             |         | skos    | http://www.w3.org/2004/02/skos/core#",
      "                             |         | cv      | http://data.europa.eu/m8g",
      "  |   |   | Country          |         | id      |",
      "  |   |   |   | id           | integer |         |",
      "  |   |   |   | code         | string  |         |",
      "  |   |   |   | name@lt      | string  |         |",
      "  |   |   | City             |         | id      |",
      "  |   |   |   | id           | integer |         |",
      "  |   |   |   | name@lt      | string  |         |",
      "  |   |   |   | country      | ref     | Country |",
    }),
  }),
  s("tdsa", {
    t({
      "m | property | type    | ref     | level",
      "Country      |         | id      |",
      "  | id       | integer |         |",
      "  | code     | string  |         |",
      "  | name@lt  | string  |         |",
      "City         |         | id      |",
      "  | id       | integer |         |",
      "  | name@lt  | string  |         |",
      "  | country  | ref     | Country |",
    }),
  }),
})

