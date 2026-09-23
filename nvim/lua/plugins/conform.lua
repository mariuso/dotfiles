return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      vue = false,
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true,
    },
    formatters = {
      ["google-java-format"] = {
        prepend_args = { "--aosp" }, -- Use AOSP style (4-space indentation)
      },
    },
  },
}