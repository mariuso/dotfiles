return {
  "mg979/vim-visual-multi",
  branch = "master",
  config = function()
    -- Default keybindings:
    -- Ctrl+n - select words
    -- Ctrl+Up/Down - create cursors vertically
    -- n/N - get next/previous occurrence
    -- q - skip current and get next occurrence
    -- Q - remove current cursor/selection
    -- Tab - switch between cursor and extend mode
    
    -- Custom settings
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",           -- select word under cursor
      ["Find Subword Under"] = "<C-n>",   -- select subword under cursor
      ["Skip Region"] = "q",               -- skip current and select next
      ["Remove Region"] = "Q",             -- remove current cursor
      ["Select Cursor Down"] = "<C-Down>", -- create cursor down
      ["Select Cursor Up"] = "<C-Up>",     -- create cursor up
    }
    
    -- Theme
    vim.g.VM_theme = "iceblue"
    
    -- Show messages
    vim.g.VM_verbose_commands = 0
    
    -- Mouse support
    vim.g.VM_mouse_mappings = 1
  end,
}