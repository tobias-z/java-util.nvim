local Job = require("plenary.job")

local helpers = {}

local builders_dir = "lua/tests/testproject/src/main/java/io/github/tobiasz/testproject/builders"
local snapshots_dir = "lua/tests/java_util/snapshots"

function helpers.wait_for_ready_lsp()
  local succeeded, _ = vim.wait(20000, vim.lsp.buf.server_ready)

  if not succeeded then
    error("LSP server was never ready.")
  end
end

function helpers.build_snapshot(snapshot_file, test_file)
  local file = string.format("%s/%s.java", builders_dir, snapshot_file)
  print("Building snapshot for: " .. snapshot_file .. " using builder: " .. test_file)

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
          [[luafile lua/tests/java_util/util/setup_jdtls.lua]],
          "-c",
          string.format("e %s", file),
          "-c",
          [[lua require("tests.java_util.util.helpers").wait_for_ready_lsp()]],
          "-c",
          string.format([[luafile %s/lua/tests/java_util/builders/%s.lua]], vim.fn.getcwd(), test_file),
          "-c",
          string.format("wq! %s/%s.snapshot", snapshots_dir, snapshot_file),
        },
        on_stdout = function(_, data)
          print(data)
        end,
      })
      -- Might need to up this
      :sync(20000)
end

function helpers.snapshot_matches(snapshot, match)
  local file = string.format("%s/%s.snapshot", snapshots_dir, snapshot)
  local snapshot_content = vim.fn.join(vim.fn.readfile(file), "\n")
  return snapshot_content == match
end

return helpers
