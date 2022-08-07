vim.api.nvim_create_user_command("JavaUtil", function(opts)
  require("java_util.command").run_command(opts.fargs[1])
end, {
  nargs = "*",
  complete = function(_, line)
    local lsp = vim.tbl_keys(require("java_util.command").commands)

    local split_new_line = vim.split(line, "%s+")

    local is_cmd_name = (#split_new_line - 2) == 0
    if is_cmd_name then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, split_new_line[2])
      end, vim.tbl_extend("force", lsp, {}))
    end

    return {}
  end,
})
