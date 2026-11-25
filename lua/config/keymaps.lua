local keymap = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap.set("n", "<leader>ma", "<cmd>Mason<cr>", { desc = "Mason" })

keymap.set("", "<F1>", "<nop>")

local colorschemes = {
	{ theme = "parsee", plugin = "parsee.nvim" },
	{ theme = "everforest", plugin = "everforest-nvim" },
}
local current_idx = 1

keymap.set("n", "<Leader>tc", function()
	current_idx = current_idx + 1
	if current_idx > #colorschemes then
		current_idx = 1
	end

	local target = colorschemes[current_idx]
	local theme = target.theme
	local plugin = target.plugin

	local has_lazy, lazy = pcall(require, "lazy")
	if has_lazy and plugin then
		lazy.load({ plugins = { plugin } })
	end

	local success, _ = pcall(function()
		vim.cmd.colorscheme(theme)
	end)

	if success then
		print("Colorscheme: " .. theme)
	else
		print("Failed to change colorscheme: " .. theme)
	end
end, { desc = "Toggle Colorscheme" })

local function parse_int(text, base)
	text = vim.trim(text)
	if base == 16 then
		text = text:gsub("^0[xX]", "")
	end
	local n = tonumber(text, base)
	if not n or n ~= math.floor(n) then
		return nil
	end
	return n
end

local function get_segments()
	local mode = vim.fn.mode()
	local p1, p2 = vim.fn.getpos("v"), vim.fn.getpos(".")
	local opts = { type = mode }
	local lines = vim.fn.getregion(p1, p2, opts)
	local pos = vim.fn.getregionpos(p1, p2, opts)

	local function seg(text, s, e)
		return { text = text, srow = s[2] - 1, scol = s[3] - 1, erow = e[2] - 1, ecol = e[3] }
	end

	if mode == "\22" then
		local segs = {}
		for i, p in ipairs(pos) do
			-- 短い行で選択範囲が空になった場合は飛ばす
			if vim.trim(lines[i]) ~= "" then
				table.insert(segs, seg(lines[i], p[1], p[2]))
			end
		end
		return segs
	end

	return { seg(table.concat(lines, "\n"), pos[1][1], pos[#pos][2]) }
end

local function convert(base, fmt, title, replace)
	return function()
		local segs = get_segments()
		if #segs == 0 then
			vim.notify("Nothing to convert", vim.log.levels.WARN)
			return
		end

		local outs = {}
		for i, s in ipairs(segs) do
			local n = parse_int(s.text, base)
			if not n then
				vim.notify(("Not a valid integer: %q"):format(vim.trim(s.text)), vim.log.levels.ERROR)
				return
			end
			outs[i] = string.format(fmt, n)
		end

		if replace then
			for i = #segs, 1, -1 do
				local s = segs[i]
				vim.api.nvim_buf_set_text(0, s.srow, s.scol, s.erow, s.ecol, { outs[i] })
			end
			vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
		else
			vim.fn.setreg("+", table.concat(outs, "\n"))
		end
		vim.notify(table.concat(outs, "\n"), vim.log.levels.INFO, { title = title })
	end
end

vim.keymap.set("x", "<leader>x", convert(10, "0x%x", "dec → hex"), { desc = "convert dec to hex" })
vim.keymap.set("x", "<leader>d", convert(16, "%d", "hex → dec"), { desc = "convert hex to dec" })
vim.keymap.set("x", "<leader>X", convert(10, "0x%x", "dec → hex", true), { desc = "replace dec with hex" })
vim.keymap.set("x", "<leader>D", convert(16, "%d", "hex → dec", true), { desc = "replace hex with dec" })
