return {
  'echasnovski/mini.map',
  version = false,
  config = function()
    local minimap = require('mini.map')
    minimap.setup({
      -- Highlight integrations (none by default)
      integrations = {
        minimap.gen_integration.builtin_search(),
        minimap.gen_integration.gitsigns(),
        minimap.gen_integration.diagnostic(),
      },
      -- Symbols used to display data
      symbols = {
        encode = minimap.gen_encode_symbols.dot('4x2'),
      },
      -- Window options
      window = {
        side = 'right',
        width = 20,
        winblend = 25,
        show_integration_count = true,
      },
    })
    
    -- Auto-open minimap
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        minimap.open()
      end,
    })
    
    -- Keybindings
    vim.keymap.set('n', '<leader>mm', minimap.toggle, { desc = 'Toggle minimap' })
    vim.keymap.set('n', '<leader>mr', minimap.refresh, { desc = 'Refresh minimap' })
    vim.keymap.set('n', '<leader>ms', minimap.toggle_side, { desc = 'Toggle minimap side' })
  end,
}