return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true }) end,
        desc = "Format file",
      },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json       = { "prettier" },
        yaml       = { "prettier" },
        sh         = { "shfmt" },
        bash       = { "shfmt" },
      },
      -- Format on save; falls back to LSP if formatter not installed
      format_on_save = {
        timeout_ms   = 500,
        lsp_fallback = true,
      },
    },
  },
}
