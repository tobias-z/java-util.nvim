---@tag java_util.nvim

---@config { ["name"] = "GETTING STARTED" }

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

---@class test @Defines how the |java_util.lsp.create_test| function should behave when called. See `https://github.com/tobias-z/java-util.nvim/wiki/Creating-Tests` for in depth test configuration
---@field after_snippet function|nil: will be called after a test class is created and snippet has been inserted
---@field class_snippets table: A table of snippets that should be considered when calling the |java_util.lsp.create_test| function.

--- The setup function to tailor the experience of java-util to match your needs
---
--- The setup function has to be called for java_util to function correctly.
---
--- Default options can be found here: `https://github.com/tobias-z/java-util.nvim#configuration`
---@param opts table|nil: configuration options
---@field test test|nil: a |test| table
function java_util.setup(opts)
  opts = opts or {}
  local config = require("java_util.config")
  config.set_defaults()
  config.values = vim.tbl_deep_extend("force", config.values, opts)
  config.post_setup()

  require("java_util.springboot.setup").setup()
end

return java_util
