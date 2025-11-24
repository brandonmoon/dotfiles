return {
  {
    "nvim-neotest/neotest",
    -- commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
    branch = "fix/subprocess/load-adapters",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-jest",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    opts = function(_, opts)
      table.insert(
        opts.adapters,
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.js",
          cwd = function()
            return vim.fn.getcwd()
          end,
        })
      )
    end,
  },
}
