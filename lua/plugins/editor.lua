return {
  -- Auto close brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- gcc / gc to comment lines/selections
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Git decorations in the gutter
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "+" },
        change       = { text = "~" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "Git: " .. desc })
        end
        map("]h", gs.next_hunk,    "Next hunk")
        map("[h", gs.prev_hunk,    "Prev hunk")
        map("<leader>gs", gs.stage_hunk,   "Stage hunk")
        map("<leader>gr", gs.reset_hunk,   "Reset hunk")
        map("<leader>gp", gs.preview_hunk, "Preview hunk")
        map("<leader>gb", gs.blame_line,   "Blame line")
      end,
    },
  },

  -- ys, cs, ds to surround with brackets/quotes/tags
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- Highlight other occurrences of word under cursor
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- Better folding via LSP/Treesitter
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require("ufo").setup({
        provider_selector = function()
          return { "lsp", "indent" }
        end,
      })
      vim.keymap.set("n", "zR", require("ufo").openAllFolds,  { desc = "Open all folds" })
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
    end,
  },

  -- Smooth motion animations
  {
    "josstei/whisk.nvim",
    event = "VeryLazy",
    opts = {
      cursor = {
        duration = 150,
        easing = "ease-out",
        enabled = true,
      },
      scroll = {
        duration = 200,
        easing = "ease-in-out",
        enabled = true,
      },
    },
  },
}
