local utils = {}

local function run_build(name, cmd, cwd)
	if type(cmd) == "function" then
		local ok, err = pcall(cmd)
		if not ok then
			vim.notify(("Build failed for %s:\n%s"):format(name, err), vim.log.levels.ERROR)
		end
		return
	end

	local result = vim.system(cmd, { cwd = cwd }):wait()
	if result.code ~= 0 then
		local stderr = result.stderr or ""
		local stdout = result.stdout or ""
		local output = stderr ~= "" and stderr or stdout
		if output == "" then
			output = "No output from build command."
		end
		vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
	end
end

function utils.update_handler(name, cmd, cwd)
	local autocmd = vim.api.nvim_create_autocmd("PackChanged", {
		group = vim.api.nvim_create_augroup(name .. "-pack-changed-update-handler", { clear = true }),
		callback = function(ev)
			local package_name = ev.data.spec.name
			local kind = ev.data.kind
			if kind ~= "install" and kind ~= "update" then
				return
			end

			if package_name == name then
				run_build(name, cmd, cwd or ev.data.path)
			end
		end,
	})
	return autocmd
end

return utils
