local sev = vim.diagnostic.severity

vim.diagnostic.config({
	underline = true,
	severity_sort = true,
	update_in_insert = false, -- less flicker
	float = {
		border = "rounded",
		source = true,
	},
	signs = {
		text = {
			[sev.ERROR] = "",
			[sev.WARN] = "",
			[sev.INFO] = "",
			[sev.HINT] = "",
		},
	},
	virtual_text = false,
})
