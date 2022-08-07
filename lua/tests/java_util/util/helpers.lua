local helpers = {}

local snapshots_dir = "lua/tests/java_util/snapshots"

function helpers.wait_for_ready_lsp()
  local succeeded, _ = vim.wait(20000, vim.lsp.buf.server_ready)

  if not succeeded then
    error("LSP server was never ready.")
  end
end

function helpers.snapshot_matches(snapshot, match)
  local file = string.format("%s/%s.snapshot", snapshots_dir, snapshot)
  local snapshot_content = vim.fn.join(vim.fn.readfile(file), "\n")
  return snapshot_content == match
end

return helpers
