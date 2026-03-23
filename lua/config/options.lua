local opt      = vim.opt
local platform = require("config.platform")

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

-- Windows: use pwsh as shell so :terminal and ! commands use PowerShell
if platform.is_windows then
  opt.shell      = "pwsh"
  opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  opt.shellquote = ""
  opt.shellxquote = ""
end

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
