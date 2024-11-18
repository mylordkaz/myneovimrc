-- remap stuff

vim.g.mapleader = ' '

vim.keymap.set("n", "<D-s>", ":w<CR>", { desc = "Save" })      -- save in normal mode
vim.keymap.set("i", "<D-s>", "<Esc>:w<CR>", { desc = "Save" }) -- save in insert mode


-- window nav
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

-- System clipboard integration
vim.keymap.set('v', '<D-c>', '"+y', { desc = 'Copy to system clipboard' })       -- Cmd+c to copy
vim.keymap.set('n', '<D-v>', '"+p', { desc = 'Paste from system clipboard' })    -- Cmd+v to paste in normal mode
vim.keymap.set('i', '<D-v>', '<C-r>+', { desc = 'Paste from system clipboard' }) -- Cmd+v to paste in insert mode
vim.keymap.set('c', '<D-v>', '<C-r>+', { desc = 'Paste from system clipboard' }) -- Cmd+v to paste in command mode

-- Alternative clipboard
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })    -- Space+y to copy
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from system clipboard' }) -- Space+p to paste

-- NetRW
vim.keymap.set('n', '<leader>pv', ':Ex<CR>', { desc = 'Open NetRW file explorer' })


vim.keymap.set("x", "<leader>p", [["_dP]]) -- keep the pasted text in the buffer


-- Undo/Redo
vim.keymap.set('n', '<D-z>', 'u', { desc = 'Undo' })            -- Cmd+z to undo in normal mode
vim.keymap.set('i', '<D-z>', '<C-o>u', { desc = 'Undo' })       -- Cmd+z to undo in insert mode
vim.keymap.set('n', '<D-S-z>', '<C-r>', { desc = 'Redo' })      -- Cmd+Shift+z to redo in normal mode
vim.keymap.set('i', '<D-S-z>', '<C-o><C-r>', { desc = 'Redo' }) -- Cmd+Shift+z to redo in insert mode

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search Git files' })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })

-- Format shortcuts
vim.keymap.set('n', '<leader>f', 'gg=G<C-o>', { desc = 'Format entire file' }) -- Space+f to format whole file
vim.keymap.set('v', '<leader>f', '=', { desc = 'Format selected code' })       -- Space+f to format selection
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = 'Open diagnostics float' })
vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, { desc = 'Format file' })

-- Move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move line up' })


-- Nvim-tree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<CR>', { silent = true })
