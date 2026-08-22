vim.pack.add({
	"https://github.com/rose-pine/neovim",
})

require("rose-pine").setup({
	styles = {
		transparent = true,
	},
})

vim.cmd("colorscheme rose-pine")
