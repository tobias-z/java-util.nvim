local values = require("java_util.config").values
local request_util = require("java_util.springboot.request_util")

local home = os.getenv("HOME") -- TODO: dont keep calling this.

local springboot_config = {}

springboot_config.defaults = {}

springboot_config.defaults.name = "boot-ls"

springboot_config.defaults.cmd = {
  "java",
  "-Dsts.lsp.client=vscode",
  string.format("-Dsts.log.file=%s", values.logging_file),
  string.format("-Dlogging.file=%s", values.logging_file),
  "-jar",
  vim.fn.glob(home .. "/.local/share/jdtls/spring-boot/spring-boot-language-server-*-exec.jar"), -- TODO: use from our own built
}

springboot_config.defaults.handlers = {
  ["sts/addClasspathListener"] = function(_, result)
    return request_util.execute_jdtls_command({
      command = "sts.java.addClasspathListener",
      arguments = {
        result.callbackCommandId,
      },
    })
  end,
  ["sts/removeClasspathListener"] = function(_, result)
    return request_util.execute_jdtls_command({
      command = "sts.java.removeClasspathListener",
      arguments = {
        result.callbackCommandId,
      },
    })
  end,
  ["sts/javadocHoverLink"] = request_util.request_handler("sts.java.javadocHoverLink"),
  ["sts/javaType"] = request_util.request_handler("sts.java.type"),
  ["sts/javaSuperTypes"] = request_util.request_handler("sts.java.hierarchy.supertypes"),
  ["sts/javaCodeComplete"] = request_util.request_handler("sts.java.code.completions"),
  ["sts/javaSubTypes"] = request_util.request_handler("sts.java.hierarchy.subtypes"),
  ["sts/javaSearchPackages"] = request_util.request_handler("sts.java.search.packages"),
  ["sts/javaSearchTypes"] = request_util.request_handler("sts.java.search.types"),
  ["sts/javadoc"] = request_util.request_handler("sts.java.javadoc"),
  ["sts/javaLocation"] = request_util.request_handler("sts.java.location"),
}

springboot_config.defaults.find_root_dir = values.jdtls.config.find_root_dir

springboot_config.defaults.capabilities = vim.tbl_deep_extend("force", values.jdtls.config.capabilities, {
  workspace = {
    executeCommand = {
      dynamicRegistration = true,
    },
  },
})

function springboot_config.create_config()
  values.springboot.boot_ls = vim.tbl_deep_extend("force", springboot_config.defaults, values.springboot.boot_ls)
end

return springboot_config
