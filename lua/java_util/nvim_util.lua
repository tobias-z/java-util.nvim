local nvim_util = {}

function nvim_util.feedkeys(keys, opts)
  local replaced = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(replaced, opts or "n", true)
end

return nvim_util
