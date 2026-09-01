vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" })

require("treesitter-textobjects").setup({
	move = {
		enable = true,
		set_jumps = true,
	},
})
