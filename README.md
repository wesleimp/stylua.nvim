# stylua.nvim

stylua.nvim is a simple plugin that format your Lua code using StyLua

## Requirements

- [StyLua](https://github.com/JohnnyMorganz/StyLua)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

Install this plugin by using your favorite plugin manager

**Packer**

```lua
use({ "wesleimp/stylua.nvim" })
```

**Plug**

```vim
Plug 'wesleimp/stylua.nvim'
```

## Usage

Format you code with a simple command

```vim
:lua require("stylua").format()
```

## LICENSE

[MIT](./LICENSE)
