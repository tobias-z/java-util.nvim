local helpers = {}

function helpers.wait_for_ready_lsp()
  local succeeded, _ = vim.wait(20000, vim.lsp.buf.server_ready)
  assert.message("LSP server was never ready.").True(succeeded)
end

return helpers
