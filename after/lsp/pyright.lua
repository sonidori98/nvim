return {
	before_init = function(_, config)
		local venv = vim.fs.joinpath(config.root_dir, ".venv", "bin", "python")
		if vim.uv.fs_stat(venv) then
			config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, { pythonPath = venv })
		end
	end,
}
