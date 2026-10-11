return {
	settings = {
		texlab = {
			build = {
				args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", "%f" },
			},
		},
	},
}
