return {
  "marilari88/twoslash-queries.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    multi_line = true,
    is_enabled = true,
    highlight = "Type",
  },
  config = function(_, opts)
    require("twoslash-queries").setup(opts)
  end,
  keys = {
    { "<leader>te", "<cmd>TwoslashQueriesEnable<cr>", desc = "Enable Twoslash Queries" },
    { "<leader>td", "<cmd>TwoslashQueriesDisable<cr>", desc = "Disable Twoslash Queries" },
    { "<leader>ti", "<cmd>TwoslashQueriesInspect<cr>", desc = "Inspect Variable Type" },
    { "<leader>tr", "<cmd>TwoslashQueriesRemove<cr>", desc = "Remove Twoslash Queries" },
  },
}