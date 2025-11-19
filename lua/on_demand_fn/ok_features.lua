
function QuickGrep()
  local word = vim.fn.input("Grep for > ")
  if word ~= "" then
    vim.cmd("vimgrep /"..word.."/gj **/*")
    vim.cmd("copen")
  end
end

vim.api.nvim_set_keymap('n', '<leader>fg', ':lua QuickGrep()<CR>', { noremap = true, silent = true })

-- Function to toggle cursor crosshair
local crosshair_enabled = false

function ToggleCursorCrosshair()
  crosshair_enabled = not crosshair_enabled
  
  if crosshair_enabled then
    vim.opt.cursorline = true
    vim.opt.cursorcolumn = true
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#404040' })
    vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#404040' })
    print("Cursor crosshair enabled")
  else
    vim.opt.cursorline = false
    vim.opt.cursorcolumn = false
    print("Cursor crosshair disabled")
  end
end

-- Create a command to call the function
vim.api.nvim_create_user_command('ToggleCrosshair', ToggleCursorCrosshair, {})

-- Map it to a key (e.g., <leader>ch for "crosshair")
vim.keymap.set('n', '<leader>ch', ToggleCursorCrosshair, { desc = 'Toggle cursor crosshair' })
