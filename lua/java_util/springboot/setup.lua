local springboot_clients = require("java_util.springboot.springboot_clients")
local boot_ls_config = require("java_util.config").values.springboot.boot_ls
local jdtls_config = require("java_util.config").values.jdtls.config
local jdtls = require("jdtls")

local setup = {}

-- TODO: allow java 9 or lower using tools.jar

function setup.setup()
  local springboot_group = vim.api.nvim_create_augroup("JAVA_UTIL_SPRINGBOOT", {
    clear = true,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "java", "jproperties", "yaml" },
    group = springboot_group,
    callback = setup._start_or_attach,
  })
end

function setup._start_or_attach()
  jdtls_config.root_dir = jdtls_config.find_root_dir()
  local on_attach = jdtls_config.on_attach
  jdtls_config.on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    boot_ls_config.root_dir = boot_ls_config.find_root_dir()
    springboot_clients.boot_ls:start(boot_ls_config)
  end

  jdtls.start_or_attach(jdtls_config)
end

return setup
