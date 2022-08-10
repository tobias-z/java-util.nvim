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

return lsp
