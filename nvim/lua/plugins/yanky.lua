vim.pack.add({
	"https://github.com/gbprod/yanky.nvim",
})

require("yanky").setup({
	highlight = {
		timer = 150,
	},
})

-- stylua: ignore start
vim.keymap.set({ "n", "x" }, "<leader>y", require("snacks").picker.yanky, { desc = "Yank History" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set("n", "<C-p>", "<Plug>(YankyCycleForward)")
vim.keymap.set("n", "<C-n>", "<Plug>(YankyCycleBackward)")
-- stylua: ignore end
