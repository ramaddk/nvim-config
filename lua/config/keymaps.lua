local map        = vim.keymap.set
local is_windows = vim.fn.has("win32") == 1

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Move lines in visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- File
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Lazygit floating window
map("n", "<leader>gg", function()
  local buf = vim.api.nvim_create_buf(false, true)
  local width  = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width    = width,
    height   = height,
    row      = math.floor((vim.o.lines - height) / 2),
    col      = math.floor((vim.o.columns - width) / 2),
    style    = "minimal",
    border   = "rounded",
  })
  vim.fn.termopen("lazygit", {
    on_exit = function() vim.api.nvim_win_close(win, true) end,
  })
  vim.cmd("startinsert")
end, { desc = "Lazygit" })

-- Terminal toggle
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  -- Hide if currently visible
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end
  -- Re-open existing buffer
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
  vim.cmd("botright 35split")
    term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term_win, term_buf)
    vim.cmd("startinsert")
    return
  end
  -- Create fresh terminal (use pwsh on Windows, default shell elsewhere)
  vim.cmd("botright 35split | terminal" .. (is_windows and " pwsh" or ""))
  term_buf = vim.api.nvim_get_current_buf()
  term_win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
end

map("n", "<leader>t", toggle_terminal, { desc = "Toggle terminal" })
map("t", "<leader>t", function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
  end
end, { desc = "Hide terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Run in terminal (PowerShell ISE-style)
local function send_to_terminal(text)
  -- Open terminal if not already open
  if not (term_buf and vim.api.nvim_buf_is_valid(term_buf)) then
    toggle_terminal()
  elseif not (term_win and vim.api.nvim_win_is_valid(term_win)) then
    toggle_terminal()
  end
  local chan = vim.b[term_buf].terminal_job_id
  if chan then
    vim.fn.chansend(chan, text .. "\n")
    -- Scroll terminal to bottom
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_call(term_win, function() vim.cmd("normal! G") end)
    end
  end
end

-- <leader>rr — run current line in pwsh
map("n", "<leader>rr", function()
  local line = vim.api.nvim_get_current_line()
  if is_windows then
    -- Terminal is already running pwsh — send line directly to avoid quoting issues
    send_to_terminal(line)
  else
    send_to_terminal("pwsh -NoProfile -Command " .. vim.fn.shellescape(line))
  end
end, { desc = "Run line in PowerShell" })

-- <leader>rr — run visual selection in pwsh via temp .ps1 file
map("v", "<leader>rr", function()
  local s     = vim.fn.getpos("'<")
  local e     = vim.fn.getpos("'>")
  local lines = vim.api.nvim_buf_get_lines(0, s[2] - 1, e[2], false)
  local tmp   = vim.fn.tempname() .. ".ps1"
  vim.fn.writefile(lines, tmp)
  if is_windows then
    -- Dot-source the file so variables remain in scope; single-quote the path for pwsh
    send_to_terminal(". '" .. tmp:gsub("'", "''") .. "'")
  else
    send_to_terminal("pwsh -NoProfile -File " .. vim.fn.shellescape(tmp))
  end
end, { desc = "Run selection in PowerShell" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic float" })
