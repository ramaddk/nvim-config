return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              schema = {
                model = {
                  -- Change to any model from: ollama list
                  default = "qwen2.5-coder:7b",
                },
              },
            })
          end,
        },
        strategies = {
          chat   = { adapter = "ollama" },
          inline = { adapter = "ollama" },
          agent  = { adapter = "ollama" },
        },
        display = {
          chat = {
            window = {
              layout = "vertical",
              width  = 0.35,
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>",  desc = "AI Chat" },
      { "<leader>aa", "<cmd>CodeCompanionChat Add<cr>",     mode = "v",           desc = "Add to AI Chat" },
      { "<leader>ae", "<cmd>CodeCompanion<cr>",             mode = { "n", "v" },  desc = "AI Inline" },
      { "<leader>ac", "<cmd>CodeCompanionActions<cr>",      desc = "AI Actions" },
    },
  },
}
