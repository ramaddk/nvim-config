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
}
