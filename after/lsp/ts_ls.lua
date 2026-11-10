-- ts_lsは頼まないとインレイヒントを返さないので，VSCodeと同じ程度に出させる
local inlay_hints = {
	includeInlayParameterNameHints = "literals",
	includeInlayFunctionParameterTypeHints = true,
	includeInlayVariableTypeHints = false,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayEnumMemberValueHints = true,
}

return {
	settings = {
		typescript = { inlayHints = inlay_hints },
		javascript = { inlayHints = inlay_hints },
	},
}
