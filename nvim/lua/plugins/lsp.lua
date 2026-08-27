local function augroup(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("lsp-attach"),
	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		--
		-- In this case, we create a function that lets us more easily define mappings specific
		-- for LSP related items. It sets the mode, buffer and description for us each time.
		local map = function(keys, func, desc, mode, opts)
			opts = opts or {}
			opts.buffer = event.buf
			opts.desc = desc
			vim.keymap.set(mode or "n", keys, func, opts)
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		local supports = function(method)
			return client:supports_method(method, event.buf)
		end

		-- nowait: `gr` would otherwise wait on the default grr/grn/gra/gri/grt maps
		-- map("gr", vim.lsp.buf.references, "References", "n", { nowait = true })
		-- map("gI", vim.lsp.buf.implementation, "Goto Implementation")
		-- map("gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition")
		-- map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("K", vim.lsp.buf.hover, "Hover")

		if supports("textDocument/definition") then
			map("gd", vim.lsp.buf.definition, "Goto Definition")
		end

		if supports("textDocument/signatureHelp") then
			map("gK", vim.lsp.buf.signature_help, "Signature Help")
			map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
		end

		if supports("textDocument/codeAction") then
			map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
		end

		if supports("textDocument/codeLens") then
			map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "x" })
			map("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
		end

		if supports("textDocument/rename") then
			map("<leader>cr", vim.lsp.buf.rename, "Rename")
		end

		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		if supports("textDocument/documentHighlight") then
			local highlight_augroup = augroup("lsp-highlight")
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = augroup("lsp-detach"),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
				end,
			})
		end

		-- The following code creates a keymap to toggle inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		-- if client and client:supports_method("textDocument/inlayHint", event.buf) then
		-- 	map("<leader>cth", function()
		-- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		-- 	end, "Toggle Inlay Hints")
		-- end
	end,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
	-- clangd = {},
	-- gopls = {},
	-- pyright = {},
	-- rust_analyzer = {},
	--
	-- Some languages (like typescript) have entire language plugins that can be useful:
	--    https://github.com/pmizio/typescript-tools.nvim
	--
	-- But for many setups, the LSP (`ts_ls`) will work just fine
	-- ts_ls = {},

	stylua = {}, -- Used to format Lua code

	-- Special Lua Config, as recommended by neovim help docs
	lua_ls = {
		on_init = function(client)
			client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
			client.config.settings.Lua = vim.tbl_deep_extend("force", current_settings.Lua, {
				runtime = {
					version = "LuaJIT",
					path = { "lua/?.lua", "lua/?/init.lua" },
				},
				workspace = {
					checkThirdParty = false,
					-- NOTE: this is a lot slower and will cause issues when working on your own configuration.
					--  See https://github.com/neovim/nvim-lspconfig/issues/3189
					library = vim.api.nvim_get_runtime_file("", true),
				},
			})
		end,
		---@type lspconfig.settings.lua_ls
		settings = {
			Lua = {
				format = { enable = false }, -- Disable formatting (formatting is done by stylua)
			},
		},
	},
}

vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

-- Automatically install LSPs and related tools to stdpath for Neovim
require("mason").setup({})

-- Translates between nvim-lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server)
require("mason-lspconfig").setup({
	automatic_enable = false, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
})

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	-- You can add other tools here that you want Mason to install
})

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

for name, server in pairs(servers) do
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end
