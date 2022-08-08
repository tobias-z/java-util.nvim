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

local function get_package(src_root, file_location, is_test)
  local removed_beginning = string.sub(
    file_location,
    string.len(src_root) + 1 + string.len(string.format("/%s/java/", is_test and "test" or "main"))
  )
  return string.gsub(removed_beginning, "/", ".")
end

function lsp_util.get_test_package(src_root, file_location)
  return get_package(src_root, file_location, true)
end

function lsp_util.get_main_package(src_root, file_location)
  return get_package(src_root, file_location, false)
end

return lsp_util
