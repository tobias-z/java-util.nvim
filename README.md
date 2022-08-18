<div align="center">

# java-util.nvim

`java-util.nvim` aims to provide extra functionality that extend the defaults of jdtls

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
![Main build](https://img.shields.io/github/workflow/status/tobias-z/java-util.nvim/Validate?label=main%20build)
![Main build](https://img.shields.io/github/workflow/status/tobias-z/java-util.nvim/Validate/dev?label=dev%20build)

</div>

## Table of Contents

- [Getting Started](#getting-started)
- [Usage](#usage)
- [Features](#features)
  - [LSP](#lsp)
- [Configuration](#configuration)

## Getting Started

The plugin is tested against [Neovim (v0.7.0)](https://github.com/neovim/neovim/releases/tag/v0.7.0) and the latest neovim nightly commit, so it is unknown if earlier versions work correctly.

### Requirements

- Jdtls setup using either [lsp-config](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jdtls) or [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls). (or anything that uses the built in neovim lsp)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### Installation

The plugin can be installed just like any other neovim plugin manager.

You could install `java-util.nvim` using:

- `main` branch
- `dev` branch (Will have the latest features)
- Any release tag

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "tobias-z/java-util.nvim",
  branch = "main",
  -- or branch = "dev"
  -- or tag = "0.1.0"
  requires = {
    { "nvim-treesitter/nvim-treesitter" }
  }
})
```

### Setup

To make `java-util` work correctly you must call the setup function.

```lua
require("java_util").setup({})
```

## Usage

Functions can be executed through either user commands or calling lua functions.

Example using lua

```lua
local opts = {
  noremap = true,
  silent = true,
--  buffer = bufnr (if this is done during an lsp on_attach)
}

vim.keymap.set("n", "<leader>rr", require("java_util.lsp").rename, opts)
```

Example using vimscript

```viml
nnoremap <leader>rr <cmd>JavaUtil lsp_rename<cr>
```

## Features

For more in depth information about specific functions see `:help java_util`

### LSP

| Functions         | Description                                                                                                                                                                                                              |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `lsp.rename`      | Renames the word you are hovering. Supports lombok renaming                                                                                                                                                              |
| `lsp.create_test` | Creates a test class for the current class you are in. Allows for multiple test class configurations. For more information see [Test Management](https://github.com/tobias-z/java-util.nvim/wiki/Test-Management)        |
| `lsp.goto_test`   | Bidirectional test movement, will either to go test or main class, depending on where you are. For more information see [Going to Tests](https://github.com/tobias-z/java-util.nvim/wiki/Test-Management#going-to-tests) |

## Configuration

In depth configuration for specific items can be found in [the wiki](https://github.com/tobias-z/java-util.nvim/wiki).

The default options to this function are as follows:

```lua
require("java_util").setup({
  test = {
    use_defaults = true,
    after_snippet = nil,
    class_snippets = {
      ["Basic"] = function(info)
        local has_luasnip, luasnip = pcall(require, "luasnip")
        if not has_luasnip then
          return string.format(
            [[
package %s;

public class %s {

}]],
            info.package,
            info.classname
          )
        end

        return luasnip.parser.parse_snippet(
          "_",
          string.format(
            [[
package %s;

public class %s {

  $0
}]],
            info.package,
            info.classname
          )
        )
      end
    },
  },
})
```

## Contributing

Looking to contribute? Please read the [CONTRIBUTING.md](./CONTRIBUTING.md) file, which contains information about making a PR.

Any feedback is very appreciated!
