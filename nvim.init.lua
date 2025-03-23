-- Disable unused providers to reduce noise in :checkhealth
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Force true colors (already working in iTerm2, but ensuring compatibility)
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
  vim.env.TERM = "xterm-256color"
  vim.cmd([[let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"]])
  vim.cmd([[let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"]])
end

-- Bootstrap Lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic settings
vim.g.mapleader = " " -- Space as leader key
vim.opt.number = true -- Line numbers (absolute)
vim.opt.relativenumber = false -- Disable relative line numbers
vim.opt.expandtab = true -- Spaces over tabs
vim.opt.shiftwidth = 4 -- 2 spaces for indent
vim.opt.tabstop = 4 -- 2 spaces for tab
vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard for yanking and pasting
vim.opt.undofile = true -- Enable undofile
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo" -- Set undo directory
vim.opt.undolevels = 1000 -- Maximum number of changes that can be undone
vim.opt.undoreload = 10000 -- Maximum number of lines to save for undo on a buffer reload
vim.opt.mouse = "a" -- Enable mouse support in all modes

-- Ensure the undo directory exists
vim.fn.mkdir(vim.fn.stdpath("state") .. "/undo", "p")

-- Load plugins with Lazy.nvim
require("lazy").setup({

 -- toggleterm for better terminals 
  {'akinsho/toggleterm.nvim', version = "*", config = true},
 -- Git integration with vim-fugitive
  {
    "tpope/vim-fugitive",
    -- No config needed; fugitive works out of the box
     cmd = { "G", "Git" }, -- Lazy-load on :G or :Git commands
  },
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup {}
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  -- Fuzzy finder (loaded on demand for better performance)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        print("Telescope failed to load")
        return
      end
      telescope.setup {}
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    end,
  },

  -- LSP support
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      -- Handler to show LSP startup errors
      local on_attach = function(client, bufnr)
        if not client.server_capabilities.definitionProvider then
          print("LSP " .. client.name .. " does not support go-to-definition")
        end
      end

      -- Python LSP (Pyright) with workspace diagnostics enabled
      lspconfig.pyright.setup {
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              diagnosticMode = "workspace",
            },
          },
        },
      }
      -- TypeScript/JavaScript LSP (ts_ls)
      lspconfig.ts_ls.setup {
        on_attach = on_attach,
      }
      -- C/C++ LSP (clangd)
      lspconfig.clangd.setup {
        on_attach = on_attach,
      }
      -- Rust LSP (rust-analyzer)
      lspconfig.rust_analyzer.setup {
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      }
      -- Custom function to provide feedback for go-to-definition
      local function goto_definition()
        local result = vim.lsp.buf.definition()
        if not result then
          print("Definition not found")
        end
      end
      vim.keymap.set("n", "gd", goto_definition, { silent = true })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { silent = true })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      }
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python", "lua", "c", "javascript", "typescript", "cpp", "rust" },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup {
        options = {
          theme = "tokyonight",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- LSP status widget (fidget.nvim)
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {
        progress = {
          display = {
            render_limit = 16,
            done_ttl = 3,
            done_icon = "✔",
            progress_icon = { "dots" },
          },
        },
        notification = {
          window = {
            winblend = 0,
            align = "bottom",
          },
        },
      }
    end,
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        style = "storm",
        transparent = false,
        terminal_colors = true,
      }
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Commenting plugin (optional enhancement)
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Git signs in the gutter (optional enhancement)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
}, {
  checker = {
    enabled = true,
  },
  -- Luarocks is enabled by default since we removed the rocks section
})

-- Custom keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true }) -- Quick save
vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true }) -- Quick quit
vim.keymap.set("n", "<C-h>", "<C-w>h", {}) -- Window navigation
vim.keymap.set("n", "<C-j>", "<C-w>j", {})
vim.keymap.set("n", "<C-k>", "<C-w>k", {})
vim.keymap.set("n", "<C-l>", "<C-w>l", {})

-- Remap delete commands to use the unnamed register (not system clipboard)
vim.keymap.set({"n", "v"}, "d", [[""d]], { silent = true }) -- Delete in normal and visual mode
vim.keymap.set({"n", "v"}, "D", [[""D]], { silent = true }) -- Delete to end of line
vim.keymap.set({"n", "v"}, "x", [[""x]], { silent = true }) -- Delete character under cursor
vim.keymap.set({"n", "v"}, "X", [[""X]], { silent = true }) -- Delete character before cursor

-- Map left mouse click to move cursor and enter insert mode
-- vim.keymap.set("n", "<LeftMouse>", "<LeftMouse>:startinsert<CR>", { silent = true })

-- Add your favorite Vim keybindings here
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", { silent = true }) -- New tab
vim.keymap.set("n", "<leader>[", ":tabprev<CR>", { silent = true }) -- Previous tab
vim.keymap.set("n", "<leader>]", ":tabnext<CR>", { silent = true }) -- Previous tab

vim.keymap.set("n", "<leader>s", ":ToggleTerm direction=vertical<CR>", { silent = true }) -- Start a terminal
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)

-- Map Command+/ to comment out lines or selections
vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { silent = true }) -- Comment line in normal mode
vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { silent = true }) -- Comment selection in visual mode
