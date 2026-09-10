-- ============================================================
-- Settings
-- ============================================================

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"

-- Mouse
opt.mouse = "a"
opt.mousemoveevent = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Undo
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Scrolling
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Commands
vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")
