return {
	-- lua/plugins/rose-pine.lua
	"rose-pine/neovim",
	name = "rose-pine-moon",
	config = function()
		require("rose-pine").setup({
			dark_variant = "moon", -- main, moon, or dawn
			styles = {
				bold = true,
				italic = true,
				transparency = false,
			},
		})
		-- vim.cmd("colorscheme rose-pine")
	end,
}
