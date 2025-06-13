return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  opts = {
    -- add any opts here
    -- provider = "azure",
    -- auto_suggestions_provider = "azure",
    provider = "copilot",
    providers = {
      copilot = {
        model = "gpt-4.1",
      },
    },
    -- azure = {
    --   endpoint = "https://dchenkpmg-openai.openai.azure.com",
    --   deployment = "dchenkpmg",
    --   model = "dchenkpmg",
    --   api_version = "2024-02-01",
    --   max_tokens = 4096,
    -- },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "zbirenbaum/copilot.lua", -- for providers='copilot'
    --- The below is optional, make sure to setup it properly if you have lazy=true
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
