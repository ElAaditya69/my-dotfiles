-- ============================================================
-- Plugins (lazy.nvim)
-- ============================================================

return {

  -- Color scheme
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({ contrast = "medium" })
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = { enabled = true },
          window = { position = "left", width = 30 },
          filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_by_name = { "node_modules", "__pycache__", ".DS_Store", "Thumbs.db", "*.pyc" },
          },
        },
        default_component_configs = { indent = { with_expanders = true } },
        window = { mappings = { ["<space>"] = "none", ["H"] = "toggle_hidden" } },
      })
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>E", ":Neotree focus<CR>", { desc = "Focus file explorer" })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      require("telescope").setup({ defaults = { preview = { treesitter = false } } })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "c", "python", "php", "javascript", "typescript", "lua", "html", "css", "json" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({ check_ts = true }) end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.enable({ "pyright", "ts_ls", "clangd" })
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },

  -- Mason
  { "williamboman/mason.nvim", config = function() require("mason").setup() end },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "ts_ls", "clangd" },
      })
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = { "black", "prettier", "stylua", "clang-format" },
      })
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = { { "<leader>f", function() require("conform").format({ async = true }) end, desc = "Format file" } },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          lua = { "stylua" },
          c = { "clang-format" },
          html = { "prettier" },
          css = { "prettier" },
          json = { "prettier" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
    end,
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "                                                     ",
        "   █████╗ ███████╗██╗   ██╗███╗   ██╗███████╗████████╗",
        "  ██╔══██╗██╔════╝██║   ██║████╗  ██║██╔════╝╚══██╔══╝",
        "  ███████║█████╗  ██║   ██║██╔██╗ ██║█████╗     ██║   ",
        "  ██╔══██║██╔══╝  ██║   ██║██║╚██╗██║██╔══╝     ██║   ",
        "  ██║  ██║██║     ╚██████╔╝██║ ╚████║███████╗   ██║   ",
        "  ╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ",
        "                                                     ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("w", "  Find text", ":Telescope live_grep<CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      alpha.setup(dashboard.config)
    end,
  },

  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          indicator = { icon = "▎", style = "icon" },
          buffer_close_icon = "󰅖",
          modified_icon = "● ",
          left_trunc_marker = " ",
          right_trunc_marker = " ",
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 20,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          offsets = {{ filetype = "neo-tree", text = "File Explorer", text_align = "center", separator = true }},
        },
      })
      vim.keymap.set("n", "<leader>bp", ":BufferLineTogglePin<CR>", { desc = "Pin buffer" })
      vim.keymap.set("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
      vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { desc = "Next buffer" })
      vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "│" }, change = { text = "│" }, delete = { text = "_" },
          topdelete = { text = "‾" }, changedelete = { text = "~" }, untracked = { text = "┆" },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts) opts = opts or {}; opts.buffer = bufnr; vim.keymap.set(mode, l, r, opts) end
          map("n", "]c", function() if vim.wo.diff then return "]c" end; vim.schedule(function() gs.next_hunk() end); return "<Ignore>" end, { expr = true })
          map("n", "[c", function() if vim.wo.diff then return "[c" end; vim.schedule(function() gs.prev_hunk() end); return "<Ignore>" end, { expr = true })
          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
          map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end)
        end,
      })
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function() vim.o.timeout = true; vim.o.timeoutlen = 300 end,
    opts = {},
    config = function()
      local wk = require("which-key")
      wk.setup({ plugins = { spelling = { enabled = true } } })
      wk.add({
        { "<leader>f", group = "Find/Format" },
        { "<leader>ff", desc = "Find files" },
        { "<leader>fg", desc = "Search text" },
        { "<leader>fb", desc = "Find buffers" },
        { "<leader>ft", desc = "Next TODO" },
        { "<leader>FT", desc = "Previous TODO" },
        { "<leader>e", desc = "Toggle file explorer" },
        { "<leader>E", desc = "Focus file explorer" },
        { "<leader>w", desc = "Save file" },
        { "<leader>W", desc = "Force save" },
        { "<leader>q", desc = "Quit file" },
        { "<leader>Q", desc = "Force quit all" },
        { "<leader>x", desc = "Close buffer" },
        { "<leader>X", desc = "Force close buffer" },
        { "<leader>n", desc = "New buffer" },
        { "<leader>N", desc = "New buffer (insert)" },
        { "<leader>s", desc = "Save and close" },
        { "<leader>sa", desc = "Save file as..." },
        { "<leader>u", desc = "Toggle undo tree" },
        { "<leader>t", desc = "Toggle floating terminal" },
        { "<leader>T", desc = "Horizontal terminal" },
        { "<A-i>", desc = "Toggle floating terminal (Alt)" },
        { "<leader>ca", desc = "Code actions" },
        { "<leader>rn", desc = "Rename" },
        { "<leader>b", group = "Buffer" },
        { "<leader>bp", desc = "Pin buffer" },
        { "<leader>bo", desc = "Close other buffers" },
        { "<leader>h", group = "Git hunk" },
        { "<leader>hs", desc = "Stage hunk" },
        { "<leader>hr", desc = "Reset hunk" },
        { "<leader>hp", desc = "Preview hunk" },
        { "<leader>hb", desc = "Blame line" },
        { "<leader>z", group = "Zen" },
        { "<leader>zz", desc = "Toggle Zen mode" },
        { "<leader>c", group = "Comment" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>xx", desc = "Toggle diagnostics" },
        { "<leader>xd", desc = "Buffer diagnostics" },
        { "<leader>xq", desc = "Quickfix list" },
        { "<leader>j", desc = "Jump to word (Hop)" },
        { "<leader>J", desc = "Jump to line (Hop)" },
        { "<leader>k", desc = "Jump to char (Hop)" },
        { "<leader>q", group = "Session" },
        { "<leader>qs", desc = "Restore session" },
        { "<leader>ql", desc = "Restore last session" },
        { "<leader>qd", desc = "Stop session" },
        { "<leader>fp", desc = "Switch project" },
        { "<leader>g", desc = "Open Git" },
        { "gc", desc = "Comment toggle (line)" },
        { "gc", desc = "Comment toggle (visual)", mode = "v" },
        { "ys", desc = "Add surround" },
        { "ds", desc = "Delete surround" },
        { "cs", desc = "Change surround" },
      })
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = { char = "│", tab_char = "│" },
        scope = { enabled = true, show_start = true, show_end = false },
        exclude = { filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason" } },
      })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function get_name() return "Aaditya69" end
      require("lualine").setup({
        options = {
          theme = "gruvbox",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype", "diagnostics" },
          lualine_y = { "progress", "location" },
          lualine_z = { { get_name, color = { fg = "#fabd2f", gui = "bold" } } },
        },
      })
    end,
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("Comment").setup({ toggler = { line = "gcc" }, opleader = { line = "gc" } }) end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end,
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        keywords = {
          FIX = { icon = " ", color = "error" },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning" },
          NOTE = { icon = " ", color = "hint" },
          PERF = { icon = " ", color = "default" },
        },
      })
      vim.keymap.set("n", "<leader>ft", function() require("todo-comments").jump_next() end)
      vim.keymap.set("n", "<leader>FT", function() require("todo-comments").jump_prev() end)
    end,
  },

  -- Zen mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({
        window = { width = 0.85, height = 0.90 },
        plugins = { options = { enabled = true, ruler = false, showcmd = false }, twilight = { enabled = false }, gitsigns = { enabled = false } },
      })
      vim.keymap.set("n", "<leader>zz", ":ZenMode<CR>", { desc = "Toggle Zen mode" })
    end,
  },

  -- Trouble
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({ position = "bottom", height = 10, icons = true, use_diagnostic_signs = true })
      vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>")
      vim.keymap.set("n", "<leader>xd", ":Trouble diagnostics toggle filter.buf=0<CR>")
      vim.keymap.set("n", "<leader>xq", ":Trouble quickfix toggle<CR>")
    end,
  },

  -- Hop
  {
    "smoka7/hop.nvim",
    event = "VeryLazy",
    config = function()
      require("hop").setup({ case_insensitive = true, char2_fallback_key = "<CR>" })
      vim.keymap.set("n", "<leader>j", ":HopWord<CR>")
      vim.keymap.set("n", "<leader>J", ":HopLine<CR>")
      vim.keymap.set("n", "<leader>k", ":HopChar1<CR>")
    end,
  },

  -- Colorizer
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("colorizer").setup({ "css", "html", "javascript", "lua", "python", "*" }, { mode = "background" }) end,
  },

  -- Notify
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local ok, notify = pcall(require, "notify")
      if ok then
        notify.setup({
          timeout = 2000,
          max_height = function() return math.floor(vim.o.lines * 0.75) end,
          max_width = function() return math.floor(vim.o.columns * 0.75) end,
          render = "compact",
          stages = "fade",
          background_colour = "#1a1a1a",
        })
        vim.notify = notify
      end
    end,
  },

  -- Startup time
  { "dstein64/vim-startuptime", cmd = "StartupTime", config = function() vim.g.startuptime_tries = 10 end },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function() require("neoscroll").setup({ stop_eof = true, easing_function = "sine", cursor_scrolls_alone = true }) end,
  },

  -- Session manager
  {
    "folke/persistence.nvim",
    event = "VeryLazy",
    config = function()
      require("persistence").setup({ dir = vim.fn.stdpath("data") .. "/sessions/", options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } })
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end)
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end)
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end)
    end,
  },

  -- Grug far
  { "MagicDuck/grug-far.nvim", cmd = "GrugFar", config = function() require("grug-far").setup({}) end },

  -- Fidget
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = function() local ok, fidget = pcall(require, "fidget"); if ok then fidget.setup({}) end end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function() vim.g.undotree_SplitWidth = 30; vim.g.undotree_SetFocusWhenToggle = 1 end,
  },

  -- Toggleterm
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "float" then
            return { width = math.floor(vim.o.columns * 0.60), height = math.floor(vim.o.lines * 0.60) }
          else
            return 15
          end
        end,
        open_mapping = [[<leader>t]],
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        direction = "float",
        float_opts = { border = "curved" },
        close_on_exit = true,
        shell = vim.o.shell,
      })
      vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>")
      vim.keymap.set("t", "<leader>t", "<cmd>ToggleTerm<CR>")
      vim.keymap.set("n", "<leader>T", "<cmd>ToggleTerm direction=horizontal<CR>")
      vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
    end,
  },

  -- FTerm
  {
    "numToStr/FTerm.nvim",
    event = "VeryLazy",
    config = function()
      require("FTerm").setup({ border = "rounded", dimensions = { height = 0.60, width = 0.60 }, auto_close = true })
      vim.keymap.set("n", "<A-i>", function() require("FTerm").toggle() end)
      vim.keymap.set("t", "<A-i>", function() require("FTerm").toggle() end)
      vim.keymap.set("t", "<Esc>", function() require("FTerm").close() end)
      vim.api.nvim_create_user_command("CodeRun", function()
        vim.cmd("w")
        local filetype = vim.bo.filetype
        local filename = vim.fn.expand("%:p")
        local name = vim.fn.expand("%:t:r")
        local cmd = ""
        if filetype == "c" then
          cmd = "gcc -o '" .. name .. "' '" .. filename .. "' && ./" .. "'" .. name .. "'"
        elseif filetype == "python" then
          cmd = "python3 '" .. filename .. "'"
        elseif filetype == "javascript" then
          cmd = "node '" .. filename .. "'"
        elseif filetype == "lua" then
          cmd = "lua '" .. filename .. "'"
        else
          print("Cannot run " .. filetype .. " files")
          return
        end
        require("FTerm").run(cmd)
      end, {})
    end,
  },

  -- Project switcher
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({ patterns = { ".git", "package.json", "Cargo.toml", "go.mod" } })
      require("telescope").load_extension("projects")
      vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>")
    end,
  },

  -- Neogit
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require("neogit").setup({ integrations = { diffview = true } })
      vim.keymap.set("n", "<leader>g", ":Neogit<CR>")
    end,
  },

  -- Scrollbar
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup({
        show = true,
        handle = { color = "#665c54" },
        marks = {
          Search = { color = "#fabd2f" }, Error = { color = "#fb4934" },
          Warn = { color = "#fe8019" }, Info = { color = "#83a598" },
          Hint = { color = "#8ec07c" }, Misc = { color = "#928374" },
        },
      })
    end,
  },

  -- Rainbow delimiters
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local rainbow = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = { strategy = { [""] = rainbow.strategy["global"] }, query = { [""] = "rainbow-delimiters" } }
    end,
  },

}
