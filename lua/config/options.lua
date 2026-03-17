local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false

-- Appearance
opt.termguicolors = true
opt.signcolumn = "auto"
opt.cursorline = true
opt.wrap = false
opt.fillchars = { eob = " " }
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Behaviour
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"
opt.mouse = "a"

-- Use a decent built-in colorscheme (no plugin needed)
vim.cmd.colorscheme("habamax")

-- Open Telescope find_files when launched with no arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        require("telescope.builtin").find_files()
      end)
    end
  end,
})
