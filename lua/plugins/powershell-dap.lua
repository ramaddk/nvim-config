return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      {
        "m00qek/baleia.nvim",
        version = "v1.4.0",
        lazy = true,
      },
      "Willem-J-an/nvim-dap-powershell",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      require("dap-powershell").setup({
        include_configs = true,
        pses_bundle_path = vim.fn.expand("~/.local/share/powershell-es"),
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        require("dap-powershell").correct_repl_colors()
      end

      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step out" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
    end,
  },
}
