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
  branch = "main"
  -- or branch = "dev"
  -- or tag = "0.1.0"
  requires = {
    { "nvim-treesitter/nvim-treesitter" }
  }
})
```

## Usage

Functions can be executed through either user commands or calling lua functions

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

| Functions    | Description                                                 |
| ------------ | ----------------------------------------------------------- |
| `lsp.rename` | Renames the word you are hovering. Supports lombok renaming |

## Contributing

Looking to contribute? Please read the [CONTRIBUTING.md](./CONTRIBUTING.md) file, which contains information about making a PR.

Any feedback is very appreciated!
