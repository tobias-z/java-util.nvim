---@diagnostic disable: unused-local

local config = {}

_JavaUtilConfigValues = _JavaUtilConfigValues or {}

config.values = _JavaUtilConfigValues

function config.set_defaults()
  config.values = {
    lsp = {
      test = {
        use_defaults = true,
      },
    },
  }
end

local function create_test_defaults()
  local test = config.values.lsp.test
  if not test.after_snippet then
    config.values.lsp.test.after_snippet = function(opts)
      local has_jdtls, jdtls = pcall(require, "jdtls")
      if has_jdtls then
        jdtls.organize_imports()
      end
    end
  end

  if not test.class_snippets["Basic"] then
    config.values.lsp.test.class_snippets["Basic"] = function(info)
      local has_luasnip, luasnip = pcall(require, "luasnip")
      if not has_luasnip then
        return string.format(
          [[
package %s;

public class %s {

}
                      ]],
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
}
                      ]],
          info.package,
          info.classname
        )
      )
    end
  end
end

function config.post_setup()
  if config.values.lsp.test.use_defaults then
    create_test_defaults()
  end
end

return config
