return {
  "stevearc/oil.nvim",
  keys = {
    { "<leader>o", "<cmd>Oil --float<CR>", desc = "Oil Explorer" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    float = {
      padding = 5,
      border = "rounded",
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
