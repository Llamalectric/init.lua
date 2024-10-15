local harpoon = require 'harpoon'

harpoon:setup()

vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = '[A]dd current file to harpoon' })
vim.keymap.set('n', '<C-e>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Toggle harpoon menu' })

-- Navigation
vim.keymap.set('n', '<C-h>', function()
  harpoon:list():select(1)
end, { desc = 'Go to harpoon file 1' })
vim.keymap.set('n', '<C-j>', function()
  harpoon:list():select(2)
end, { desc = 'Go to harpoon file 2' })
vim.keymap.set('n', '<C-k>', function()
  harpoon:list():select(3)
end, { desc = 'Go to harpoon file 3' })
vim.keymap.set('n', '<C-l>', function()
  harpoon:list():select(4)
end, { desc = 'Go to harpoon file 4' })
