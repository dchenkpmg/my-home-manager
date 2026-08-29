local sev = vim.diagnostic.severity

vim.diagnostic.config({
	-- keep underline & severity_sort on for quick scanning
	underline = true,
	severity_sort = true,
	update_in_insert = false, -- less flicker
	float = {
		border = "rounded",
		source = true,
	},
	-- keep signs & virtual text, but tune them as you like
	signs = {
		text = {
			[sev.ERROR] = "",
			[sev.WARN] = "",
			[sev.INFO] = "",
			[sev.HINT] = "",
		},
	},
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
	},
})
