return {
	settings = {
		["rust-analyzer"] = {
			-- 保存時のチェックをcargo checkより細かいclippyにする
			check = {
				command = "clippy",
			},
		},
	},
}
