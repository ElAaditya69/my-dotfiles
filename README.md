# Aaditya's Neovim Config

Professional Neovim setup built from scratch with lazy.nvim.

## Structure

```
nvim/
├── init.lua              # Main entry point
├── lua/
│   ├── settings.lua      # Vim options
│   ├── keymaps.lua       # Key bindings
│   └── plugins/
│       └── init.lua      # All plugins
└── .gitignore
```

## Features

- **Colorscheme:** Gruvbox
- **File Explorer:** Neo-tree
- **Fuzzy Finder:** Telescope
- **Syntax:** Treesitter
- **LSP:** pyright, ts_ls, clangd
- **Autocomplete:** nvim-cmp
- **Formatting:** conform.nvim
- **Git:** gitsigns, neogit
- **Terminal:** FTerm, toggleterm
- **Dashboard:** alpha-nvim
- **Status Line:** lualine
- **And more...**

## Install

```bash
git clone https://github.com/Aaditya69/my-dotfiles ~/.config/nvim
```

## Key Bindings

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `jk` | Exit insert mode |
| `Space w` | Save file |
| `Space e` | Toggle file explorer |
| `Space ff` | Find files |
| `Space fg` | Search text |
| `Space t` | Toggle terminal |
| `Option+i` | Toggle floating terminal |
| `:CodeRun` | Run current file |
| `gd` | Go to definition |
| `K` | Show documentation |
