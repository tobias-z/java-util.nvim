local java_util = {}

-- TODO: Add docs for config fields
function java_util.setup(opts)
  opts = opts or {}
  local config = require("java_util.config")
  config.set_defaults()
  config.values = vim.tbl_deep_extend("force", config.values, opts)
end

return java_util
