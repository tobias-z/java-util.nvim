---@diagnostic disable: unused-local

local config = {}

_JavaUtilConfigValues = _JavaUtilConfigValues or {}

config.values = _JavaUtilConfigValues

local home = os.getenv("HOME")

function config.set_defaults()
  config.values = {
    logging_file = home .. "/.cache/nvim/java-util.nvim.log",
    test = {
      use_defaults = true,
      after_snippet = nil,
      class_snippets = {},
    },
    jdtls = {
      jdtls_location = home .. "/.local/share/nvim/lsp_servers/jdtls", -- TODO: make default to our built version
      lombok_support = true,
      workspace_location = home .. "/.local/share/nvim/jdtls/workspaces",
      config = {},
    },
    springboot = {
      boot_ls = {},
    },
  }
end

local function create_test_defaults()
  local test = config.values.test
  if not test.class_snippets["Basic"] then
    config.values.test.class_snippets["Basic"] = function(info)
      local has_luasnip, luasnip = pcall(require, "luasnip")
      if not has_luasnip then
        return string.format(
          [[
package %s;

public class %s {

}]],
          info.package,
          info.classname
        )
      end

      return luasnip.parser.parse_snippet(
        "_",
        string.format(
          [[
package %s;

public class %s {

    $0
}]],
          info.package,
          info.classname
        )
      )
    end
  end
end

function config.post_setup()
  if config.values.test.use_defaults then
    create_test_defaults()
  end
  require("java_util.config.jdtls_config").create_config()
  require("java_util.config.springboot_config").create_config()
end

return config
