return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
			},
			presets = {
				inc_rename = false,
				lsp_doc_border = false,
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			-- フェードの時に透明扱いにする色．カラースキームを切り替えても追従するようにNormalの背景色を使う
			background_colour = function()
				local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
				return normal.bg and string.format("#%06x", normal.bg) or "#000000"
			end,
		},
	},
}
