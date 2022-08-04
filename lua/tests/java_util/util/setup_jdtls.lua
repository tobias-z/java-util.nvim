local has_jdtls, jdtls = pcall(require, "jdtls")

if not has_jdtls then
  error("Missing jdtls required for running tests")
  return
end

local sys_name = vim.fn.has("mac") == 1 and "mac" or "linux"

local jdtls_location = os.getenv("JAVA_UTIL_JDTLS")
if not jdtls_location then
  error("missing env variable $JAVA_UTIL_JDTLS required to run tests.")
  return
end

local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
if root_dir == "" then
  return
end

local config = {}

-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
config.cmd = {
  "java",

  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
  "-Dosgi.bundles.defaultStartLevel=4",
  "-Declipse.product=org.eclipse.jdt.ls.core.product",
  "-Dlog.protocol=true",
  "-Dlog.level=ALL",
  "-javaagent:" .. jdtls_location .. "/lombok.jar",
  "-Xms1g",
  "--add-modules=ALL-SYSTEM",

  "--add-opens",
  "java.base/java.util=ALL-UNNAMED",
  "--add-opens",
  "java.base/java.lang=ALL-UNNAMED",

  "-jar",
  vim.fn.glob(jdtls_location .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
  "-configuration",
  jdtls_location .. "/config_" .. sys_name,
  "-data",
  string.format("%s/%s", vim.fn.getcwd(), "jdtls-workspace"),
}

config.root_dir = root_dir

local group = vim.api.nvim_create_augroup("JDTLS_GROUP", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  group = group,
  callback = function()
    jdtls.start_or_attach(config)
  end,
})
