local keymap = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap.set("n", "<leader>ma", "<cmd>Mason<cr>", { desc = "Mason" })

keymap.set("", "<F1>", "<nop>")

local colorschemes = {
	{ theme = "parsee", plugin = "parsee.nvim" },
	{ theme = "gruvbox", plugin = "gruvbox.nvim" },
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

local function get_selection()
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
	return table.concat(lines, "\n")
end

local function parse_int(text, base)
	text = vim.trim(text)
	if base == 16 then
		text = text:gsub("^0[xX]", "")
	end
	local n = tonumber(text, base)
	if not n then
		vim.notify("Selected text is not a valid integer", vim.log.levels.ERROR)
	end
	return n
end

local function convert(base, fmt, title)
	return function()
		local n = parse_int(get_selection(), base)
		if not n then
			return
		end
		local out = string.format(fmt, n)
		vim.fn.setreg("+", out)
		vim.notify(out, vim.log.levels.INFO, { title = title })
	end
end

vim.keymap.set("x", "<leader>x", convert(10, "0x%x", "dec → hex"), { desc = "convert dec to hex" })
vim.keymap.set("x", "<leader>d", convert(16, "%d", "hex → dec"), { desc = "convert hex to dec" })
