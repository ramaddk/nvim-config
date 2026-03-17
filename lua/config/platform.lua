local M = {}

M.is_windows = vim.fn.has("win32") == 1
M.is_mac     = vim.fn.has("mac") == 1
M.is_linux   = vim.fn.has("unix") == 1 and not M.is_mac

return M
