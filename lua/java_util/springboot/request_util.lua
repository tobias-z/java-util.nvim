local request_util = {}

function request_util.execute_jdtls_command(command_params)
  local candidates = vim.lsp.get_active_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = require("java_util.config").values.jdtls.config.name,
  })

  local cand_count = vim.tbl_count(candidates)
  if cand_count > 1 or cand_count == 0 then
    return
  end

  -- TODO: Check if client can execute it
  return candidates[1].request_sync("workspace/executeCommand", command_params)
end

function request_util.request_handler(command_name)
  return function(_, result)
    return request_util.execute_jdtls_command({
      command = command_name,
      arguments = result,
    })
  end
end

return request_util
