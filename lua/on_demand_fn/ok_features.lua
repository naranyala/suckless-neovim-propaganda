function GoToDefinition()
    -- Check if an LSP client is attached to the current buffer
    if next(vim.lsp.get_active_clients()) then
        -- Execute the built-in LSP command to go to definition
        vim.lsp.buf.definition()
    else
        -- Fallback to Ctags-style navigation if no LSP is available
        -- This uses the standard Vim tag search command
        vim.cmd('tag ' .. vim.fn.expand('<cword>'))
    end
end

function FindReferences()
    -- Check if an LSP client is attached
    if next(vim.lsp.get_active_clients()) then
        -- Execute the built-in LSP command to find references
        vim.lsp.buf.references()
    else
        print("No active LSP client for finding references.")
    end
end

local opts = { noremap = true, silent = true }

-- Go to Definition
vim.keymap.set('n', 'gd', GoToDefinition, opts)

-- Find References
vim.keymap.set('n', 'gr', FindReferences, opts)

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
