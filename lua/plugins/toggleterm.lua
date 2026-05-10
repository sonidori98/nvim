return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		open_mapping = [[<c-\>]],
		shell = vim.o.shell,
		direction = "float",
		float_opts = {
			border = "curved",
			winblend = 30,
		},
	},
}
