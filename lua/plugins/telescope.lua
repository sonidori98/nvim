return {
	"nvim-telescope/telescope.nvim",
	version = "*",
	dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
	opts = {},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Telescope help tags" },
		{
			"gd",
			"<cmd>Telescope lsp_definitions<cr>",
			desc = "Telescope go to definition",
			mode = "n",
		},
		{
			"grr",
			"<cmd>Telescope lsp_references<cr>",
			desc = "Telescope go to references",
			mode = "n",
		},
		{
			"gri",
			"<cmd>Telescope lsp_implementations<cr>",
			desc = "Telescope go to implementations",
			mode = "n",
		},
		{
			"grt",
			"<cmd>Telescope lsp_type_definitions<cr>",
			desc = "Telescope go to type definition",
			mode = "n",
		},
	},
}
