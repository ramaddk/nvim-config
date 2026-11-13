return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      suggestion = { enabled = false },
      panel      = { enabled = false },
    },
  },
  {
    "creeper5820/opencode.nvim",
    cmd = {
      "OpenCode",
      "OpenCodeToggle",
      "OpenCodeOpen",
    },
    keys = {
      {
        "<leader>ao",
        "<cmd>OpenCodeToggle<cr>",
        desc = "OpenCode",
      },
    },
    opts = {
      keymaps = {
        toggle = false,
        send_selection = "<leader>os",
        question_selection = "<leader>oq",
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    opts = {},
    keys = {
      { "<leader>ai", "<cmd>CopilotChatToggle<cr>",   desc = "AI Chat" },
      { "<leader>aa", "<cmd>CopilotChat<cr>",         mode = "v",          desc = "Add to AI Chat" },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>",  mode = { "n", "v" }, desc = "AI Inline" },
      { "<leader>ac", "<cmd>CopilotChatPrompts<cr>",  desc = "AI Actions" },
    },
  },
}
