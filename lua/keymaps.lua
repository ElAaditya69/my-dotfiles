-- ============================================================
-- Keymaps
-- ============================================================

local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>W", ":w!<CR>", { desc = "Force save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit file" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit all" })
map("n", "<leader>x", ":bd<CR>", { desc = "Close current buffer" })
map("n", "<leader>X", ":bd!<CR>", { desc = "Force close buffer" })
map("n", "<leader>n", ":enew<CR>", { desc = "New empty buffer" })
map("n", "<leader>N", ":enew<CR>i", { desc = "New buffer (insert mode)" })
map("n", "<leader>s", ":w<CR>:bd<CR>", { desc = "Save and close" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window resize
map("n", "<leader>+", ":vertical resize +5<CR>", { desc = "Make window wider" })
map("n", "<leader>-", ":vertical resize -5<CR>", { desc = "Make window narrower" })
map("n", "<leader>=", "<C-w>=", { desc = "Equal split sizes" })

-- Navigation
map("n", "<C-o>", "<C-o>", { desc = "Jump back" })
map("n", "<C-i>", "<C-i>", { desc = "Jump forward" })

-- Marks
map("n", "m", "m", { desc = "Set mark" })
map("n", "'", "'", { desc = "Jump to mark" })

-- Undo tree
map("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle undo tree" })

-- Save as
map("n", "<leader>sa", function()
  local filename = vim.fn.input("Save as: ", "", "file")
  if filename ~= "" then
    vim.cmd("w " .. filename)
  end
end, { desc = "Save file as..." })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })

-- Indent in visual mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
