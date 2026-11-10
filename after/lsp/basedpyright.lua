return {
	settings = {
		basedpyright = {
			analysis = {
				-- 既定の"recommended"は警告が多すぎるので，Pylanceに近い程度にする
				typeCheckingMode = "standard",
			},
		},
	},
}
