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
---@param opts table
---@field lsp table
function java_util.setup(opts)
  opts = opts or {}
  local config = require("java_util.config")
  config.set_defaults()
  config.values = vim.tbl_deep_extend("force", config.values, opts)
  config.post_setup()
end

return java_util
