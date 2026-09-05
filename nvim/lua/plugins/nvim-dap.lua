vim.pack.add({
	{ src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
})
vim.pack.add({ "https://github.com/mfussenegger/nvim-dap" })
vim.pack.add({ "https://github.com/mfussenegger/nvim-dap-python" })

require("dap-view").setup({
	auto_toggle = true,
})
require("dap-python").setup("debugpy-adapter")

local dap = require("dap")

-- stylua: ignore start
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "DapStoppedLine" })
vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError" })
vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo" })
-- stylua: ignore end

local node_adapter = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = { "${port}" },
	},
	enrich_config = function(conf, on_config)
		if not vim.startswith(conf.type, "pwa-") then
			local config = vim.deepcopy(conf)
			config.type = "pwa-" .. config.type
			on_config(config)
		else
			on_config(conf)
		end
	end,
}

dap.adapters["node"] = node_adapter
dap.adapters["pwa-node"] = node_adapter

local skip_files = { "<node_internals>/**", "node_modules/**" }
local source_maps = { "${workspaceFolder}/**", "!**/node_modules/**" }

dap.configurations["typescript"] = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		runtimeExecutable = "tsx",
		skipFiles = skip_files,
		resolveSourceMapLocations = source_maps,
	},
	{
		type = "pwa-node",
		request = "attach",
		name = "Attach",
		processId = require("dap.utils").pick_process,
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		runtimeExecutable = "tsx",
		skipFiles = skip_files,
		resolveSourceMapLocations = source_maps,
	},
}

-- ---@param config {type?:string, args?:string[]|fun():string[]?}
-- local function get_args(config)
-- 	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
-- 	local args_str = type(args) == "table" and table.concat(args, " ") or args

-- 	config = vim.deepcopy(config)
-- 	config.args = function()
-- 		local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str))
-- 		if config.type and config.type == "java" then
-- 			return new_args
-- 		end
-- 		return require("dap.utils").splitstr(new_args)
-- 	end
-- 	return config
-- end

-- stylua: ignore start
vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Breakpoint Condition" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Run/Continue" })
-- vim.keymap.set("n", "<leader>da", function() require("dap").continue({ before = get_args }) end, { desc = "Run with Args" })
vim.keymap.set("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", function() require("dap").goto_() end, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", function() require("dap").down() end, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", function() require("dap").up() end, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dp", function() require("dap").pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", function() require("dap").session() end, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dv", "<CMD>DapViewToggle!<CR>", { desc = "DAP View" })
vim.keymap.set("n", "<leader>dw", "<CMD>DapViewWatch<CR>", { desc = "DAP Watch" })
-- stylua: ignore end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		-- stylua: ignore start
		vim.keymap.set("n", "<leader>dPt", function() require("dap-python").test_method() end, { desc = "Debug Method" })
		vim.keymap.set("n", "<leader>dPf", function() require("dap-python").test_class() end, { desc = "Debug Class" })
		-- stylua: ignore end
	end,
})
