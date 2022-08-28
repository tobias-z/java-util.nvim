local LspClient = require("java_util.lsp_client")

local springboot_clients = {}

springboot_clients.boot_ls = LspClient:new({
  get_client_id = function(client, config)
    local root_dir = vim.loop.fs_realpath(config.root_dir)
    return client.client_ids[root_dir]
  end,
  set_client_id = function(client, config, client_id)
    client.client_ids[config.root_dir] = client_id
  end,
})

return springboot_clients
