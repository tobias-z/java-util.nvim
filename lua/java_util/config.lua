---@diagnostic disable: unused-local

local config = {}

_JavaUtilConfigValues = _JavaUtilConfigValues or {}

config.values = _JavaUtilConfigValues

function config.set_defaults()
  config.values = {
    test = {
      use_defaults = true,
      after_snippet = nil,
      class_snippets = {},
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
end

return config
