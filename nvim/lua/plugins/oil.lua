vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	float = {
		padding = 5,
		border = "rounded",
	},
})

vim.keymap.set("n", "<leader>o", "<cmd>Oil --float<CR>", { desc = "Oil Explorer" })
