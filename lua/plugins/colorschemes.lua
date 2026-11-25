return {
	{
		"sonidori98/parsee.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("parsee")
		end,
	},

	{
		"neanias/everforest-nvim",
		lazy = true,
		main = "everforest",
		opts = {
			background = "hard",
		},
	},
}
