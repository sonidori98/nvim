local textlint_severity = {
	[1] = vim.diagnostic.severity.WARN,
	[2] = vim.diagnostic.severity.ERROR,
	[3] = vim.diagnostic.severity.INFO,
}

local function parse_textlint(output, bufnr)
	-- 設定ファイルが無い時などはJSONが返ってこない
	local ok, results = pcall(vim.json.decode, output)
	if not ok or type(results) ~= "table" then
		return {}
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	-- textlintの列はUTF-16単位(1始まり)なのでバイト位置に直す
	local function byte_col(lnum, col)
		local line = lines[lnum + 1] or ""
		return vim.str_byteindex(line, "utf-16", math.max(col - 1, 0), false)
	end

	local diagnostics = {}
	for _, result in ipairs(results) do
		for _, msg in ipairs(result.messages or {}) do
			local lnum = msg.loc.start.line - 1
			local end_lnum = msg.loc["end"].line - 1
			table.insert(diagnostics, {
				lnum = lnum,
				col = byte_col(lnum, msg.loc.start.column),
				end_lnum = end_lnum,
				end_col = byte_col(end_lnum, msg.loc["end"].column),
				severity = textlint_severity[msg.severity] or vim.diagnostic.severity.WARN,
				message = msg.message,
				source = "textlint",
				code = msg.ruleId,
			})
		end
	end
	return diagnostics
end

local textlint_rc_names = {
	[".textlintrc"] = true,
	[".textlintrc.json"] = true,
	[".textlintrc.yaml"] = true,
	[".textlintrc.yml"] = true,
	[".textlintrc.js"] = true,
	[".textlintrc.cjs"] = true,
}

-- textlintと同じようにdirから上に向かって設定ファイルを探す
local function has_textlint_config(dir)
	local found = vim.fs.find(function(name, path)
		if textlint_rc_names[name] then
			return true
		end
		-- package.jsonの"textlint"にも書ける
		if name == "package.json" then
			local ok, pkg = pcall(function()
				return vim.json.decode(table.concat(vim.fn.readfile(vim.fs.joinpath(path, name)), "\n"))
			end)
			return ok and type(pkg) == "table" and pkg.textlint ~= nil
		end
		return false
	end, { path = dir, upward = true, limit = 1 })
	return #found > 0
end

-- textlintはnvim-lintに入っていないので自分で定義する
local function textlint()
	local file = vim.api.nvim_buf_get_name(0)
	local args = { "--format", "json", "--stdin", "--stdin-filename", file }

	-- 設定が見つからない時(ホームの外のファイルなど)はホームの設定を使う
	local home_rc = vim.fs.joinpath(vim.env.HOME, ".textlintrc.json")
	if not has_textlint_config(vim.fs.dirname(file)) and vim.uv.fs_stat(home_rc) then
		vim.list_extend(args, { "--config", home_rc })
	end

	return {
		cmd = "textlint",
		stdin = true,
		args = args,
		ignore_exitcode = true,
		parser = parse_textlint,
	}
end

return {
	"mfussenegger/nvim-lint",
	ft = { "markdown", "tex" },
	config = function()
		local lint = require("lint")
		lint.linters.textlint = textlint
		lint.linters_by_ft = {
			markdown = { "textlint" },
			tex = { "textlint" },
		}

		local function try_lint()
			if vim.fn.executable("textlint") == 0 then
				return
			end
			-- textlintは実行したフォルダから上に向かって設定ファイルを探す
			lint.try_lint(nil, { cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })
		end

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("conf-lint", {}),
			callback = try_lint,
		})
		-- 読み込みのきっかけになったバッファの分
		try_lint()
	end,
}
