---@tag java_util.nvim

---@config { ["name"] = "ABOUT" }

---@brief [[
---
--- `java-util.nvim` aims to provide extra functionality that extend the defaults of jdtls
---
--- <pre>
--- Information about specific functionality can be found at: `https://github.com/tobias-z/java-util.nvim`
---
--- Or through the helptags
---
---   :h java_util.lsp
---   :h java_util.command
--- </pre>
---@brief ]]

local java_util = {}

--- The setup function to tailor the experience of java-util to match your needs
---
--- The setup function has to be called for java_util to function correctly.
---
--- Default options can be found here: `https://github.com/tobias-z/java-util.nvim#configuration`
---
---@param opts table|nil: configuration options
---@field test table|nil: Determines how tests should be created
---
--- Fields: ~
---     {after_snippet} (function|nil) function called after a class is created and snippet has been inserted
---     {class_snippets} (table) Table of the class snippets that should be considered when calling the |lsp.create_test| function
---
--- Default:
---<code>
--- test = {
---   after_snippet = nil,
---   class_snippets = {
---     ["Basic"] = function(info)
---       local has_luasnip, luasnip = pcall(require, "luasnip")
---       if not has_luasnip then
---         return string.format(
---           [[
---   package %s;
---
---   public class %s {
---
---   }]],
---           info.package,
---           info.classname
---         )
---       end
---
---       return luasnip.parser.parse_snippet(
---         "_",
---         string.format(
---           [[
---   package %s;
---
---   public class %s {
---
---     $0
---   }]],
---           info.package,
---           info.classname
---         )
---       )
---     end,
---   }
--- }
---</code>
function java_util.setup(opts)
  opts = opts or {}
  local config = require("java_util.config")
  config.set_defaults()
  config.values = vim.tbl_deep_extend("force", config.values, opts)
  config.post_setup()
end

return java_util
