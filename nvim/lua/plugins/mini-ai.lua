vim.pack.add({ "https://github.com/nvim-mini/mini.ai" })

local ai = require("mini.ai")

require("mini.ai").setup({
	n_lines = 500,
	custom_textobjects = {
		o = ai.gen_spec.treesitter({
			a = { "@block.outer", "@conditional.outer", "@loop.outer" },
			i = { "@block.inner", "@conditional.inner", "@loop.inner" },
		}),
		f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
		c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
		t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, --tags
		d = { "%f[%d]%d+" }, --digits
		e = {
			{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
			"^().*()$", --case words
		},
		u = ai.gen_spec.function_call(), --function calls
		U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), --function calls without dots
	},
})

-- stylua: ignore start
require("which-key").add({
	mode = { "o", "x" },
	{ "a", group = "around" },
	{ "i", group = "inside" },
	{ "an", group = "around next" },
	{ "in", group = "inside next" },
	{ "al", group = "around last" },
	{ "il", group = "inside last" },

	{ "ao", desc = "Around Block" },
	{ "af", desc = "Around Function" },
	{ "ac", desc = "Around Class" },
	{ "at", desc = "Around Tag" },
	{ "ad", desc = "Around Digit" },
	{ "ae", desc = "Around Case Word" },
	{ "au", desc = "Around Function Call" },
	{ "aU", desc = "Around Function Call (no dot)" },

	{ "io", desc = "Inside Block" },
	{ "if", desc = "Inside Function" },
	{ "ic", desc = "Inside Class" },
	{ "it", desc = "Inside Tag" },
	{ "id", desc = "Inside Digit" },
	{ "ie", desc = "Inside Case Word" },
	{ "iu", desc = "Inside Function Call" },
	{ "iU", desc = "Inside Function Call (no dot)" },

	{ "ano", desc = "Around Next Block" },
	{ "anf", desc = "Around Next Function" },
	{ "anc", desc = "Around Next Class" },
	{ "ant", desc = "Around Next Tag" },
	{ "and", desc = "Around Next Digit" },
	{ "ane", desc = "Around Next Case Word" },
	{ "anu", desc = "Around Next Function Call" },
	{ "anU", desc = "Around Next Function Call (no dot)" },

	{ "ino", desc = "Inside Next Block" },
	{ "inf", desc = "Inside Next Function" },
	{ "inc", desc = "Inside Next Class" },
	{ "int", desc = "Inside Next Tag" },
	{ "ind", desc = "Inside Next Digit" },
	{ "ine", desc = "Inside Next Case Word" },
	{ "inu", desc = "Inside Next Function Call" },
	{ "inU", desc = "Inside Next Function Call (no dot)" },

	{ "alo", desc = "Around Last Block" },
	{ "alf", desc = "Around Last Function" },
	{ "alc", desc = "Around Last Class" },
	{ "alt", desc = "Around Last Tag" },
	{ "ald", desc = "Around Last Digit" },
	{ "ale", desc = "Around Last Case Word" },
	{ "alu", desc = "Around Last Function Call" },
	{ "alU", desc = "Around Last Function Call (no dot)" },

	{ "ilo", desc = "Inside Last Block" },
	{ "ilf", desc = "Inside Last Function" },
	{ "ilc", desc = "Inside Last Class" },
	{ "ilt", desc = "Inside Last Tag" },
	{ "ild", desc = "Inside Last Digit" },
	{ "ile", desc = "Inside Last Case Word" },
	{ "ilu", desc = "Inside Last Function Call" },
	{ "ilU", desc = "Inside Last Function Call (no dot)" },
})
-- stylua: ignore end
