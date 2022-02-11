# stylua.nvim

stylua.nvim is a simple plugin that format you Lua code using StyLua

## Requirements

- [StyLua](https://github.com/JohnnyMorganz/StyLua)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

## Installation

**Packer**

```lua
use({ "wesleimp/stylua.nvim" })
```

**Plug**

```vim
Plug 'wesleimp/stylua.nvim'
```

## Usage

```vim
:lua require("stylua").format()
```

## LICENSE

[MIT](./LICENSE)
