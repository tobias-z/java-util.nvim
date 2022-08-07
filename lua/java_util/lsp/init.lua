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

return lsp
