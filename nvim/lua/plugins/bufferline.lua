vim.pack.add({
	"https://github.com/akinsho/bufferline.nvim",
})

require("bufferline").setup({
	options = {
		-- stylua: ignore
		close_command = function(n) Snacks.bufdelete(n) end,
		-- stylua: ignore
		right_mouse_command = function(n) Snacks.bufdelete(n) end,
		diagnostics = "nvim_lsp",
		always_show_bufferline = false,
		offsets = {
			{
				filetype = "snacks_layout_box", -- for snacks explorer?
			},
		},
		diagnostics_indicator = function(_, _, diag)
			local ret = (diag.error and " " .. diag.error .. " " or "")
				.. (diag.warning and " " .. diag.warning or "")
			return vim.trim(ret)
		end,
	},
})

vim.keymap.set("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle Pin" })
vim.keymap.set("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete Non-Pinned Buffers" })
vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete Buffers to the Right" })
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete Buffers to the Left" })
vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "[B", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move Buffer Prev" })
vim.keymap.set("n", "]B", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move Buffer Next" })
vim.keymap.set("n", "<leader>bj", "<Cmd>BufferLinePick<CR>", { desc = "Pick Buffer" })
