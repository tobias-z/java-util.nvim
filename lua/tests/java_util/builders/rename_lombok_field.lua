vim.api.nvim_win_set_cursor(0, { 12, 19 })
require("java_util.lsp").rename("changed")
vim.wait(2000)
