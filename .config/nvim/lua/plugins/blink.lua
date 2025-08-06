return {
  "saghen/blink.cmp",
  dependencies = {
    {
      "Exafunction/codeium.nvim",
    },
  },
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "codeium" },
      providers = {
        codeium = { name = "Codeium", score_offset = 100, module = "codeium.blink", async = true },
      },
    },
  },
}
