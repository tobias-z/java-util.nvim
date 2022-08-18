local Job = require("plenary.job")

local plenary_util = {}

---Executes any command through plenary
---@param opts table: the options
---@field cmd string: the command you want to run
---@field cwd string|nil: the current working directory to run the command from
---@field process_result function: will be called whenever the process outputs something
---@field process_complete function: will be called when the process is finished
function plenary_util.execute_with_results(opts)
  Job:new({
    command = opts.cmd,
    cwd = opts.cwd,
    args = opts.args,
    on_stdout = function(_, line, _)
      if not line or line == "" then
        return
      end

      opts.process_result(line)
    end,
    on_exit = function()
      opts.process_complete()
    end,
  }):start()
end

return plenary_util
