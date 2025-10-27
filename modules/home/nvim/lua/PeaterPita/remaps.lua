vim.g.mapleader = " "

-- Default Binds
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true})
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left>")



-- Stay in V mode while indenting --
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")



vim.keymap.set({'n', 'v'}, "<leader>y", '"+y')


vim.keymap.set({'n', 'v'}, "<leader>p", '"+p')








-- Exit keybind
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

