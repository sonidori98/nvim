return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	-- lazy = false,
	keys = {
		{ "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Neo-tree toggle" },
	},
	opts = {
		close_if_last_window = true,
	},
}
