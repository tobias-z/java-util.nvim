local Job = require("plenary.job")

local helpers = {}

local builders_dir = "lua/tests/testproject/src/main/java/io/github/tobiasz/testproject/builders"
local snapshots_dir = "lua/tests/testproject/src/main/java/io/github/tobiasz/testproject/snapshots"

function helpers.wait_for_ready_lsp()
  local succeeded, _ = vim.wait(20000, vim.lsp.buf.server_ready)
  if not succeeded then
    error("LSP server was never ready.")
  end
end

-- TODO: Setup java for ci tests
function helpers.build_snapshot(snapshot_file, test_file)
  local file = string.format("%s/%s", builders_dir, snapshot_file)

  Job
    :new({
      command = "nvim",
      args = {
        "--noplugin",
        "-u",
        "scripts/minimal.vim",
        "-c",
        "set noswapfile",
        "-c",
        [[lua require("tests.java_util.util.setup_jdtls")]],
        "-c",
        string.format("e %s", file),
        "-c",
        [[lua require("tests.java_util.util.helpers").wait_for_ready_lsp()]],
        "-c",
        string.format([[luafile %s]], string.format("lua/tests/java_util/builders/%s", test_file .. ".lua")),
        "-c",
        string.format("wq! %s/%s", snapshots_dir, snapshot_file),
      },
    })
    -- Might need to up this
    :sync(20000)
end

function helpers.snapshot_matches(snapshot, match)
  local file = string.format("%s/%s", snapshots_dir, snapshot)
  local snapshot_content = vim.fn.join(vim.fn.readfile(file), "\n")
  return snapshot_content == match
end

return helpers
