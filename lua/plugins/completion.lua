local ollama_ok = vim.fn.executable("ollama") == 1

local deps = {
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",
}

if ollama_ok then
  table.insert(deps, {
    "tzachar/cmp-ai",
    config = function()
      require("cmp_ai.config"):setup({
        max_lines              = 50,
        provider               = "Ollama",
        provider_options       = {
          model  = "qwen3-coder:30b",
          -- qwen3-coder uses the same FIM tokens as qwen2.5-coder
          prompt = function(lines_before, lines_after)
            return "<|fim_prefix|>" .. lines_before
                .. "<|fim_suffix|>" .. lines_after
                .. "<|fim_middle|>"
          end,
          options = {
            temperature = 0,
            num_predict = 80,
            stop        = { "<|endoftext|>", "<|fim_pad|>" },
          },
        },
        notify                 = false,
        run_on_every_keystroke = true,
      })
      require("cmp_ai").setup()
    end,
  })
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = deps,
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      local sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }
      if ollama_ok then
        table.insert(sources, 3, { name = "cmp_ai" })
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-j>"]     = cmp.mapping.select_next_item(),
          ["<C-k>"]     = cmp.mapping.select_prev_item(),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources(sources),
      })
    end,
  },
}
