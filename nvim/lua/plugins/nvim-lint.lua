vim.pack.add({
	"https://github.com/mfussenegger/nvim-lint",
})

local lint = require("lint")

lint.linters_by_ft = {
	sh = { "shellcheck" },
}

lint.linters["markdownlint-cli2"].args = {
	"--config",
	os.getenv("HOME") .. "/.markdownlint-cli2.yaml",
	"--",
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
	callback = function()
		require("lint").try_lint()
	end,
})
