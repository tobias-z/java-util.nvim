local config = require("java_util.config").values.jdtls
local home = os.getenv("HOME")

local jdtls_config = {}

jdtls_config.defaults = {}

jdtls_config.defaults.name = "jdt.ls"

jdtls_config.defaults.flags = {
  allow_incremental_sync = true,
  debounce_text_changes = 150,
}

jdtls_config.defaults.settings = {
  java = {
    eclipse = {
      downloadSources = true,
    },
    configuration = {
      updateBuildConfiguration = "interactive",
      maven = {
        userSettings = home .. "/.m2/settings.xml",
      },
    },
    errors = {
      incompleteClasspath = {
        severity = "error",
      },
    },
    autobuild = {
      enabled = true,
    },
    import = {
      gradle = {
        enabled = true,
      },
      maven = {
        enabled = true,
      },
      exclusions = {
        "**/node_modules/**",
        "**/.metadata/**",
        "**/archetype-resources/**",
        "**/META-INF/maven/**",
        "**/test/**",
      },
    },
    maven = {
      downloadSources = true,
      updateSnapshots = true,
    },
    implementationsCodeLens = {
      enabled = false,
    },
    referencesCodeLens = {
      enabled = false,
    },
    references = {
      includeDecompiledSources = true,
    },
    progressReports = {
      enabled = false,
    },
    format = {
      enabled = true,
      settings = {
        profile = "GoogleStyle",
        url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
      },
    },
  },
  signatureHelp = { enabled = true },
  completion = {
    favoriteStaticMembers = {
      "org.hamcrest.MatcherAssert.assertThat",
      "org.hamcrest.Matchers.*",
      "org.hamcrest.CoreMatchers.*",
      "org.junit.jupiter.api.Assertions.*",
      "java.util.Objects.requireNonNull",
      "java.util.Objects.requireNonNullElse",
      "org.mockito.Mockito.*",
    },
    importOrder = {
      "java",
      "javax",
      "com",
      "org",
    },
    override = false,
  },
  contentProvider = { preferred = "fernflower" },
  sources = {
    organizeImports = {
      starThreshold = 9999,
      staticStarThreshold = 9999,
    },
  },
  codeGeneration = {
    toString = {
      template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
    },
    hashCodeEquals = {
      useJava7Objects = true,
    },
    useBlocks = true,
  },
}

jdtls_config.defaults.init_options = {
  bundles = {},
}

jdtls_config.defaults.handlers = {
  ["workspace/executeClientCommand"] = function(_, command_params)
    local candidates = vim.lsp.get_active_clients({
      bufnr = vim.api.nvim_get_current_buf(),
      name = require("java_util.config").values.springboot.boot_ls.name,
    })
    local cand_count = vim.tbl_count(candidates)
    if cand_count > 1 or cand_count == 0 then
      return
    end
    return candidates[1].request_sync("workspace/executeCommand", command_params)
  end,
}

local function get_config_path(value, key_name)
  if not value or type(value) ~= "string" then
    error(string.format("incorrect value found for '%s'", key_name))
  end
  return vim.endswith(value, "/") and value or string.format("%s/", value)
end

local function has_bundle(bundle_name)
  for _, bundle in ipairs(config.config.init_options.bundles) do
    if string.find(bundle, bundle_name) then
      return true
    end
  end
  return false
end

function jdtls_config.create_config()
  if not config.config.cmd then
    local sys_name = vim.fn.has("mac") == 1 and "mac" or "linux"
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local jdtls_location = get_config_path(config.jdtls_location, "jdtls.jdtls_location")
    config.config.cmd = {
      "java",

      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      config.lombok_support and "-javaagent:" .. string.format("%slombok.jar", jdtls_location) or "", -- TODO: test if this works without lombok
      "-noverify",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",

      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      "-jar",
      vim.fn.glob(string.format("%splugins/org.eclipse.equinox.launcher_*.jar", jdtls_location)),
      "-configuration",
      string.format("%sconfig_%s", jdtls_location, sys_name),
      "-data",
      get_config_path(config.workspace_location, "jdtls.workspace_location") .. project_name,
    }
  end

  if not config.config.find_root_dir then
    config.config.find_root_dir = function()
      return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
    end
  end

  if not config.config.capabilities then
    config.config.capabilities = vim.lsp.protocol.make_client_capabilities()
  end

  config.config = vim.tbl_deep_extend("force", jdtls_config.defaults, config.config)

  if not config.config.init_options.extendedClientCapabilities then
    config.config.init_options.extendedClientCapabilities = require("jdtls").extendedClientCapabilities
  end

  -- Required for the springboot lsp to work
  if not config.config.init_options.extendedClientCapabilities.executeCommandProvider then
    config.config.init_options.extendedClientCapabilities.executeCommandProvider = {}
  end
  config.config.init_options.extendedClientCapabilities.executeCommandProvider.commands = {}

  local jar_patterns = {
    "/.local/share/jdtls/spring-boot/extension/jars/*.jar",
  }

  if not has_bundle("org.junit.platform.launcher") then
    table.insert(jar_patterns, "/config/neovim/debuggers/vscode-java-test/server/*.jar")
    table.insert(
      jar_patterns,
      "/config/neovim/debuggers/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar"
    )
    table.insert(
      jar_patterns,
      "/config/neovim/debuggers/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar"
    )
    table.insert(
      jar_patterns,
      "/config/neovim/debuggers/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar"
    )
  end

  if not has_bundle("com.microsoft.java.debug.plugin") then
    table.insert(
      jar_patterns,
      "/config/neovim/debuggers/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
    )
  end

  for _, jar_pattern in ipairs(jar_patterns) do
    for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
      if
        not vim.endswith(bundle, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
        and not vim.endswith(bundle, "com.microsoft.java.test.runner.jar")
      then
        table.insert(config.config.init_options.bundles, bundle)
      end
    end
  end
end

return jdtls_config
