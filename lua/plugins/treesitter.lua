return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then return end
      ts.setup({
        ensure_installed = {
          "bash", "css", "html", "javascript", "json",
          "lua", "markdown", "markdown_inline", "python",
          "rust", "powershell",
          "dockerfile", "toml", "hcl",
          "typescript", "tsx", "vim", "vimdoc", "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },
}
