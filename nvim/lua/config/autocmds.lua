-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.ejs",
  command = "set filetype=html",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    if vim.fn.expand("%:t") == ".env" then
      -- Disable ShellCheck or any linting for .env files
      vim.b.ale_linters = {}
      -- If using nvim-lint, you can set it to not lint .env files
      require("lint").linters_by_ft = {
        sh = {},
      }
    end
  end,
})
