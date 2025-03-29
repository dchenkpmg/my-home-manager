return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["yaml.ansible"] = { "prettier" },
        yaml = { "yamlfmt" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
    },
  },
}
