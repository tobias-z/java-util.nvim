local string_util = require("java_util.string_util")
local lsp_util = require("java_util.lsp.util")
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

function M.rename(new_name, opts)
  opts = opts or {}

  if vim.o.filetype == "java" then
    local node_at_cursor = ts_utils.get_node_at_cursor(0)
    if M._is_field(node_at_cursor) then
      M._rename_field({ new_name = new_name, opts = opts, node_at_cursor = node_at_cursor })
      return
    end
  end

  vim.lsp.buf.rename(new_name, opts)
end

function M._is_field(node)
  local first_parent = node:parent()

  if first_parent:type() == "field_access" then
    return true
  end

  if first_parent:parent():type() == "field_declaration" then
    return true
  end

  return false
end

function M._with_name(new_name, callback)
  local old_name = vim.fn.expand("<cword>")
  if new_name ~= nil then
    callback(new_name, old_name)
  else
    vim.ui.input({ prompt = "New Name:", default = old_name }, function(n_name)
      if n_name then
        callback(n_name, old_name)
      end
    end)
  end
end

function M._rename_field(opts)
  local params = vim.lsp.util.make_position_params(0)
  params.context = { includeDeclaration = true }
  lsp_util.request_all({
    { bufnr = 0, method = "textDocument/references", params = params },
    { bufnr = 0, method = "textDocument/definition", params = params },
  }, function(results)
    local references = results["textDocument/references"][1]
    local def_results = results["textDocument/definition"]
    local definitions = def_results[1]

    if #references == 0 and #definitions == 0 then
      return
    end

    -- If we are currently on the definition then textDocument/definition will not provide it to using
    -- So we have to create the entry ourselves
    local is_on_definition = #definitions == 0
    if is_on_definition then
      local context = def_results[2]
      local range = ts_utils.node_to_lsp_range(opts.node_at_cursor)
      table.insert(references, {
        uri = context.params.textDocument.uri,
        range = range,
      })
    else
      for _, def in ipairs(definitions) do
        table.insert(references, def)
      end
    end

    M._with_name(opts.new_name, function(new_name, old_name)
      local uppercase_old_name = string_util.first_to_upper(old_name)
      local uppercase_new_name = string_util.first_to_upper(new_name)
      local getter = string.format("%s%s", "get", uppercase_old_name)
      local setter = string.format("%s%s", "set", uppercase_old_name)

      for _, reference in ipairs(references) do
        local bufnr = vim.uri_to_bufnr(reference.uri)
        vim.fn.bufload(bufnr)
        local start = reference.range.start
        local the_end = reference.range["end"]
        local line =
          vim.api.nvim_buf_get_text(
            bufnr,
            start.line,
            start.character,
            the_end.line,
            the_end.character,
            {}
          )[1]
        local original_len = string.len(line)

        if string_util.starts_with(line, getter) or string_util.starts_with(line, setter) then
          local beginning = string.sub(line, 0, 3)
          local ending = string.sub(line, string.len(string.format("%s%s", beginning, uppercase_old_name)) + 1)
          line = string.format("%s%s%s", beginning, uppercase_new_name, ending)
        else
          local ending = string.sub(line, string.len(old_name) + 1)
          line = string.format("%s%s", new_name, ending)
        end

        vim.api.nvim_buf_set_text(
          bufnr,
          start.line,
          start.character,
          start.line,
          start.character + original_len,
          { line }
        )
      end
    end)
  end)
end
