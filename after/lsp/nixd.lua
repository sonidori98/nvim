-- NixOSとhome-managerのオプションを補完できるように，~/nixosのflakeを読ませる
-- desktopとlaptopでオプションはほぼ同じなのでdesktopの方を使う
local flake = '(builtins.getFlake "' .. vim.fs.joinpath(vim.env.HOME, "nixos") .. '")'
local nixos = flake .. ".nixosConfigurations.desktop.options"

return {
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import " .. flake .. ".inputs.nixpkgs { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr = nixos,
				},
				home_manager = {
					expr = nixos .. ".home-manager.users.type.getSubOptions []",
				},
			},
		},
	},
}
