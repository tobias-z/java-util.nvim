local lsp_util = require("java_util.lsp.util")
local plenary_util = require("java_util.plenary_util")
local string_util = require("java_util.string_util")

local goto_test = {}

--- Sorts the classes by classname length, smallest should be on top
--- So the closest match is always the top one
local function get_sorted_classes(classes)
  local keys = vim.tbl_keys(classes)
  return vim.fn.sort(keys, function(c1, c2)
    local c1_len = string.len(string.sub(c1, string_util.last_index_of(c1, "/") + 1))
    local c2_len = string.len(string.sub(c2, string_util.last_index_of(c2, "/") + 1))
    if c1_len > c2_len then
      return 1
    elseif c1_len == c2_len then
      return 0
    else
      return -1
    end
  end)
end

---@param opts table
---@param classes table: key is shortened classpath, value is full path
local function handle_results(opts, classes)
  local found_len = vim.tbl_count(classes)
  if found_len == 0 then
    if opts.on_no_results then
      opts.on_no_results(opts)
    end
    return
  elseif found_len == 1 then
    local first = classes[vim.tbl_keys(classes)[1]]
    lsp_util.jump_to_file(string.format("file://%s", first))
  else
    vim.ui.select(
      get_sorted_classes(classes),
      { prompt = string.format("Choose class (%d, found)", found_len) },
      function(item)
        local choosen = classes[item]
        lsp_util.jump_to_file(string.format("file://%s", choosen))
      end
    )
  end
end

local function get_search_classes(classname)
  local searches = {}
  local cur = ""
  for c in classname:gmatch(".") do
    local ascii = string.byte(c)
    local is_uppercase = ascii >= 65 and ascii <= 90
    if is_uppercase then
      if cur ~= "" then
        table.insert(searches, cur)
      end
    end
    cur = cur .. c
  end
  table.insert(searches, classname)

  -- Only search for 50% of the class names
  -- UserServiceImpl becomes { "UserServiceImpl", "UserService" } and ignores the User part
  local search_items_rounded = math.floor((vim.tbl_count(searches) / 2) + 0.5)
  local results = {}
  for i = search_items_rounded, 1, -1 do
    table.insert(results, searches[i + 1])
  end

  if vim.tbl_count(results) == 0 then
    table.insert(results, classname)
  end

  return results
end

local function with_found_classes(opts, callback)
  local cwd = vim.fn.getcwd()
  local test_classes = {}
  local args = {
    opts.cwd,
    "-type",
    "f",
  }

  local searches = get_search_classes(opts.current_class)
  for _, search_item in ipairs(searches) do
    table.insert(args, "-name")
    table.insert(args, string.format("%s*%s", search_item, opts.is_test and "" or "Test.java"))
  end
  plenary_util.execute_with_results({
    cmd = "find",
    cwd = opts.cwd,
    args = args,
    process_result = function(line)
      -- make the result start from src/...
      local shortened = string.sub(line, string.len(cwd) + 2)
      if opts.filter and type(opts.filter) == "function" then
        if not opts.filter(shortened) then
          return
        end
      end

      test_classes[shortened] = line
    end,
    process_complete = function()
      vim.schedule(function()
        callback(opts, test_classes)
      end)
    end,
  })
end

function goto_test.goto_test(opts)
  opts = opts or {}
  local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  local src_root = lsp_util.get_src_root(bufname)
  local combined_opts = vim.tbl_extend("force", {
    current_class = string.sub(bufname, string.find(bufname, "/[^/]*$") + 1, -6),
    is_test = vim.startswith(string.sub(bufname, string.len(src_root) + 1), "/test"),
  }, opts)

  if combined_opts.is_test then
    combined_opts.cwd = string.format("%s/main", src_root)
    if vim.endswith(combined_opts.current_class, "Test") then
      combined_opts.current_class = string.sub(combined_opts.current_class, 0, -5)
    end
    with_found_classes(combined_opts, function(_, classes)
      -- If we found a resulting class called the same as test class without Test in the end, we will simply use that as out result
      for key, result in pairs(classes) do
        if vim.endswith(result, string.format("%s.java", combined_opts.current_class)) then
          handle_results(combined_opts, { [key] = result })
          return
        end
      end

      handle_results(combined_opts, classes)
    end)
  else
    combined_opts.cwd = string.format("%s/test", src_root)
    with_found_classes(combined_opts, handle_results)
  end
end

return goto_test
