local lsp_util = {}

function lsp_util.request_all(requests, handler)
  local completed = {}
  local completed_count = 0
  for _, request in ipairs(requests) do
    vim.lsp.buf_request(request.bufnr, request.method, request.params, function(err, ...)
      if err then
        vim.api.nvim_err_writeln(string.format("Error when requesting method '%s': %s", request.method, err.message))
        return
      end
      completed[request.method] = { ... }
      completed_count = completed_count + 1
      if completed_count == #requests then
        handler(completed)
      end
    end)
  end
end

return lsp_util
