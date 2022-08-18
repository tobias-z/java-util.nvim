---@tag java_util.lsp

---@config { ['field_heading'] = "Options", ["module"] = "java_util.lsp" }

---@brief [[
--- The Java Util lsp module exposes a collection of functions that extend or change the functionality of the standard java language server.
---
--- The behaviour of a lot of these functions are partly inspired by how IntelliJ functions.
---@brief ]]

local lsp = {}

-- Ref: https://github.com/tjdevries/lazy.nvim
local function require_on_exported_call(mod)
  return setmetatable({}, {
    __index = function(_, picker)
      return function(...)
        return require(mod)[picker](...)
      end
    end,
  })
end

--- Rename what you are currently hovering.
--- If you are hovering a field and you are using lombok, it will also rename your getters and setters to the chosen new name.
---@param new_name string|nil: If new_name is passed you will not be prompted for a new new_name
---@param opts table|nil: options which will be passed to the |vim.lsp.buf.rename|
---@field filter function|nil: Predicate to filter clients used for rename. Receives the attached clients as argument and must return a list of clients.
---@field name string|nil: Restrict clients used for rename to ones where client.name matches this field.
lsp.rename = require_on_exported_call("java_util.lsp.internal.rename").rename

--- Create a test class for the current class you are in.
--- Uses the configuration defined in `test` see |java_util.nvim| for information about configuration.
---
--- The function will do one of three things:
---   1. No `class_snippet` found in `test.class_snippets`:
---     - Create test file and place you there.
---     - Execute the `test.after_snippet` function.
---   2. A single `class_snippet` found in `test.class_snippets`:
---     - Create test file and place you there.
---     - Execute the class_snippet.
---     - Execute the `test.after_snippet` function.
---   3. Multiple `class_snippet`'s' found in `test.class_snippets`:
---     - Create prompt to let you choose the snippet that should be used.
---     - Create test file and place you there.
---     - Execute the chosen class_snippet.
---     - Execute the `test.after_snippet` function.
---@param opts table|nil: options to specify the create_test behaviour.
---@field class_snippet string|nil: the key of one of your defined `test.class_snippets`. This will skip the prompt to select a class_snippet.
---@field testname string|nil: The name of the test you want to create. This will skip the prompt to select a testname.
lsp.create_test = require_on_exported_call("java_util.lsp.internal.create_test").create_test

--- Bidirectional test movement
--- 1. If you are in a none test class, it will go to the test of your current class. If multiple are found, a prompt is shown for you to choose
--- 2. If you are in a test class, it will go the the class you testing. If a direct match is found, it will take you directly there otherwise, it will prompt you with a list of possible matches.
---   An example of a direct match would be, you are currently in a class called UserServiceImplTest. Here a direct match would be if a class is found called UserServiceImpl
---@param opts table|nil: options to specify the goto_test behaviour.
---@field on_no_results function|nil: Called if no results are found. Could be used to create a test if no class is found
---@field current_class string|nil: Specifies the class used to search for tests/classes. Default is the current class you are in. If empty string is passed, it will show all tests found from the `opts.cwd`
---@field filter function|nil: Predicate to filter the test results. Could be used if there are some tests you always don't want to see.
---@field cwd string|nil: Specifies the cwd you want to search from. Default is the src root of the current module or project you are in.
lsp.goto_test = require_on_exported_call("java_util.lsp.internal.goto_test").goto_test

return lsp
