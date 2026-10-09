local cpp_exts = { cc = true, cpp = true, cxx = true, hh = true, hpp = true, hxx = true }

local cpp_patterns = {
	"^%s*class%s+[%w_]+%s*[{:;]",
	"^%s*class%s+[%w_]+%s*$",
	"^%s*namespace[%s%w_:]*{",
	"^%s*namespace%s+[%w_:]+%s*$",
	"^%s*template%s*<",
	"^%s*using%s+namespace%s",
	"^%s*public%s*:",
	"^%s*protected%s*:",
	"^%s*private%s*:",
	"^%s*#%s*include%s*<[%w_]+>",
	"std::",
}

local function detect_header(path, bufnr)
	local dir = vim.fs.dirname(path)
	local stem = vim.fn.fnamemodify(path, ":t:r")

	if vim.uv.fs_stat(vim.fs.joinpath(dir, stem .. ".c")) then
		return "c"
	end
	for _, ext in ipairs({ "cpp", "cc", "cxx" }) do
		if vim.uv.fs_stat(vim.fs.joinpath(dir, stem .. "." .. ext)) then
			return "cpp"
		end
	end

	if bufnr then
		for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
			for _, pattern in ipairs(cpp_patterns) do
				if line:find(pattern) then
					return "cpp"
				end
			end
		end
	end

	local c_count, cpp_count = 0, 0
	for name, type in vim.fs.dir(dir) do
		if type == "file" then
			local ext = name:match("%.(%w+)$")
			if ext == "c" then
				c_count = c_count + 1
			elseif cpp_exts[ext] then
				cpp_count = cpp_count + 1
			end
		end
	end
	if c_count > cpp_count then
		return "c"
	end

	return "cpp"
end

vim.filetype.add({
	extension = {
		h = detect_header,
	},
})
