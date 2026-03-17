return {
  { "williamboman/mason.nvim", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls", "rust_analyzer", "pyright", "powershell_es",
        "bashls", "yamlls", "dockerls", "jsonls",
      },
      automatic_installation = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd",          vim.lsp.buf.definition,                    "Go to definition")
          map("gD",          vim.lsp.buf.declaration,                   "Go to declaration")
          map("gi",          vim.lsp.buf.implementation,                "Go to implementation")
          map("K",           vim.lsp.buf.hover,                         "Hover docs")
          map("<leader>rn",  vim.lsp.buf.rename,                        "Rename")
          map("<leader>ca",  vim.lsp.buf.code_action,                   "Code action")
          map("gr",          "<cmd>Telescope lsp_references<cr>",       "References")
          map("<leader>ld",  "<cmd>Telescope diagnostics<cr>",          "Diagnostics")
        end,
      })

      -- Set capabilities globally for all servers (nvim 0.11+ API)
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- lua_ls specific settings
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace   = { checkThirdParty = false },
          },
        },
      })

      -- Disable servers that nvim-lspconfig registers but we don't want
      vim.lsp.enable("stylua", false)

      -- Enable servers. Add more here after installing via :Mason
      vim.lsp.enable({
        "lua_ls", "rust_analyzer", "pyright", "powershell_es",
        "bashls", "yamlls", "dockerls", "jsonls",
      })
    end,
  },
}
