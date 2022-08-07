---@tag java_util.command

---@config { ["module"] = "java_util.command" }

---@brief [[
---
--- Java Util functions can be run through user commands. These can be quite useful if you don't want to map everything to a keybind.
---
--- Every command is run through `JavaUtil {command}`
--- Example:
--- <pre>
--- :JavaUtil lsp_rename
--- </pre>
---
---@brief ]]

local command = {}

local function insert_command_prefix(prefix, tbl)
  local cmd_tbl = {}
  for name, fn in pairs(tbl) do
    local key = string.format("%s_%s", prefix, name)
    cmd_tbl[key] = fn
  end
  return cmd_tbl
end

local function create_command_tbl()
  local lsp = insert_command_prefix("lsp", require("java_util.lsp"))
  return lsp
end

command.commands = create_command_tbl()

function command.run_command(cmd)
  local cmd_func = command.commands[cmd]
  if not cmd_func then
    vim.notify(string.format("Unknown command %s", cmd), vim.log.levels.ERROR)
    return
  end

  cmd_func()
end

return command
