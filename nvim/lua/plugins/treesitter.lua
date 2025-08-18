return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "javascript", "typescript", "vue", "go", "xml"},
      highlight = { enable = true },
      indent = { enable = true }
    })
    
    -- Register XML parser for XSLT files
    vim.treesitter.language.register('xml', {'xsl', 'xslt'})
  end
}