---@diagnostic disable: unused-local

local config = {}

_JavaUtilConfigValues = _JavaUtilConfigValues or {}

config.values = _JavaUtilConfigValues

function config.set_defaults()
  config.values = {
    lsp = {
      test = {
        after_snippet = function(opts)
          local has_jdtls, jdtls = pcall(require, "jdtls")
          if has_jdtls then
            jdtls.organize_imports()
          end
        end,
        class_snippets = {
          ["Basic"] = function(info)
            local has_luasnip, luasnip = pcall(require, "luasnip")
            if has_luasnip then
              return string.format(
                [[
          package %s

          class %s {

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
          package %s

          class %s {

              $0
          }
                      ]],
                info.package,
                info.classname
              )
            )
          end,
        },
      },
    },
  }
end

return config
