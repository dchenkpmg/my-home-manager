vim.pack.add({
	"https://github.com/rmagatti/auto-session",
})

require("auto-session").setup({
  close_filetypes_on_save = { "checkhealth", "sidekick_terminal" },
})
