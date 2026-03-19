# nvim config

A minimal but capable Neovim setup built from scratch on top of [lazy.nvim](https://github.com/folke/lazy.nvim).
No LazyVim or other meta-distros — just the plugins I actually use.

## Requirements

- Neovim >= 0.11
- [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-bootstrapped on first launch)
- [Ollama](https://ollama.com) (for AI features — optional)
- [lazygit](https://github.com/jesseduffield/lazygit) (`brew install lazygit`)
- A [Nerd Font](https://www.nerdfonts.com) set in your terminal (for icons)

## Installation

```bash
git clone git@github.com:ramaddk/nvim-config.git ~/.config/nvim
nvim  # plugins install automatically on first launch
```

Install formatters via `:Mason`: `stylua`, `black`, `prettier`, `shfmt`

## Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP support |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/formatter installer |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocomplete |
| [cmp-ai](https://github.com/tzachar/cmp-ai) | AI completions via Ollama |
| [codecompanion.nvim](https://github.com/olimorris/codecompanion.nvim) | AI chat + inline assist |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git decorations |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Format on save |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight TODOs |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keybind hints |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Easy commenting |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto close brackets |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround motions |

## LSP Support

Installed automatically via Mason:

- **Lua** — `lua_ls`
- **Python** — `pyright`
- **Rust** — `rust_analyzer`
- **PowerShell** — `powershell_es`
- **Bash/Shell** — `bashls`
- **YAML** — `yamlls`
- **Docker** — `dockerls`
- **JSON** — `jsonls`

Add more via `:Mason`.

## Keybindings

`<leader>` = `Space`

### Files & Navigation
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>e` | Toggle file explorer |
| `<S-h>` / `<S-l>` | Prev / next buffer |
| `<C-h/j/k/l>` | Navigate windows |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `K` | Hover docs |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>ld` | Diagnostics list |
| `[d` / `]d` | Prev / next diagnostic |

### AI
| Key | Action |
|-----|--------|
| `<leader>ai` | Toggle AI chat |
| `<leader>ae` | AI inline prompt |
| `<leader>ac` | AI actions menu |
| `<leader>aa` | Add selection to chat (visual) |

AI uses [Ollama](https://ollama.com) locally with `qwen2.5-coder:7b` by default.
Change the model in `lua/plugins/ai.lua`.

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Open lazygit |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `]h` / `[h` | Next / prev hunk |

### Terminal
| Key | Action |
|-----|--------|
| `<leader>t` | Toggle terminal (35 lines) |
| `<leader>rr` | Run current line in PowerShell |
| `<leader>rr` | Run selection in PowerShell (visual) |
| `<leader>RR` | Run entire file in PowerShell |
| `<leader>rc` | Stop running script (Ctrl+C) |

### Editor
| Key | Action |
|-----|--------|
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<leader>cf` | Format file |
| `<leader>ft` | Find TODOs |
| `gcc` | Comment line |
| `gc` | Comment selection (visual) |
| `ys` / `cs` / `ds` | Surround add / change / delete |

## Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    ├── config/
    │   ├── lazy.lua       # Plugin manager bootstrap
    │   ├── options.lua    # Editor settings
    │   └── keymaps.lua    # All keymaps
    └── plugins/
        ├── ai.lua         # codecompanion + Ollama
        ├── completion.lua # nvim-cmp + cmp-ai
        ├── editor.lua     # autopairs, comments, gitsigns, surround
        ├── format.lua     # conform.nvim
        ├── lsp.lua        # LSP + Mason
        ├── telescope.lua  # Fuzzy finder
        ├── tools.lua      # todo-comments
        ├── treesitter.lua # Syntax highlighting
        └── ui.lua         # lualine, neo-tree, which-key
```
