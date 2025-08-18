return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({})

    -- Add descriptions using new v3 spec
    wk.add({
      -- Code Actions
      { "<leader>c", group = "Code Actions" },
      { "<leader>ca", desc = "Code action" },
      { "<leader>cf", desc = "Format code" },
      
      -- Diagnostics
      { "<leader>d", group = "Diagnostics" },
      { "<leader>dn", desc = "Next diagnostic" },
      { "<leader>dp", desc = "Previous diagnostic" },
      { "<leader>dl", desc = "Show diagnostic" },
      
      -- File Explorer/Neo-tree
      { "<leader>e", desc = "Toggle Neo-tree" },
      { "<leader>E", desc = "Focus Neo-tree" },
      { "<leader>n", group = "Neo-tree" },
      { "<leader>nf", desc = "Reveal file in Neo-tree" },
      { "<leader>nb", desc = "Neo-tree buffers" },
      { "<leader>ng", desc = "Neo-tree git status" },
      
      -- Find/Telescope
      { "<leader>f", group = "Find/Telescope" },
      { "<leader>fb", desc = "Find buffers" },
      { "<leader>fg", desc = "Live grep" },
      
      -- Snippets
      { "<leader>s", group = "Snippets" },
      { "<leader>se", desc = "Edit snippets" },
      
      -- Minimap
      { "<leader>m", group = "Minimap" },
      { "<leader>mm", desc = "Toggle minimap" },
      { "<leader>mr", desc = "Refresh minimap" },
      { "<leader>ms", desc = "Toggle minimap side" },
      
      -- XSLT Tools
      { "<leader>x", group = "XSLT Tools" },
      { "<leader>xl", desc = "Check XML/XSLT syntax" },
      { "<leader>xp", desc = "Run XSLT with xsltproc" },
      { "<leader>xs", desc = "Run XSLT with Saxon-HE" },
      { "<leader>xt", desc = "Choose XSLT processor" },
      
      -- LSP
      { "K", desc = "Hover documentation" },
      { "gd", desc = "Go to definition" },
      
      -- File Explorer
      { "<C-e>", desc = "Toggle Neo-tree" },
      
      -- Telescope
      { "<C-p>", desc = "Find files" },
      
      -- Completion (insert mode)
      { "<C-b>", desc = "Scroll docs up", mode = "i" },
      { "<C-f>", desc = "Scroll docs down", mode = "i" },
      { "<C-Space>", desc = "Complete", mode = "i" },
      { "<C-e>", desc = "Abort completion", mode = "i" },
      { "<CR>", desc = "Confirm completion", mode = "i" },
      { "<Tab>", desc = "Next completion/snippet", mode = "i" },
      { "<S-Tab>", desc = "Previous completion/snippet", mode = "i" },
    })
  end,
}