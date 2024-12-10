return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  opts = {
    -- add any opts here
    provider = "azure",
    auto_suggestions_provider = "azure",
    azure = {
      endpoint = "https://dchenkpmg-openai.openai.azure.com",
      deployment = "dchenkpmg",
      model = "dchenkpmg",
      api_version = "2024-02-01",
    },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
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
