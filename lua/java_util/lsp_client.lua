local LspClient = {}

function LspClient:new(opts)
  self.get_client_id = opts.get_client_id
  self.set_client_id = opts.set_client_id
  self.client_ids = {}
  return self
end

function LspClient:start(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local client_id = self:get_client_id(config)
  if client_id then
    local client = vim.lsp.get_client_by_id(client_id)
    if not client or client.is_stopped() then
      client_id = nil
    end
  end
  if not client_id then
    client_id = vim.lsp.start_client(config)
    self:set_client_id(config, client_id)
  end
  vim.lsp.buf_attach_client(bufnr, client_id)
end

return LspClient
