return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("everforest").setup({
			background = "hard",
			transparent_background_level = 0,
			italics = false,
			disable_italic_comments = false,
			sign_column_background = "none",
			ui_contrast = "low",
			dim_inactive_windows = false,
			diagnostic_text_highlight = false,
			diagnostic_virtual_text = "coloured",
			diagnostic_line_highlight = false,
			spell_foreground = false,
			show_eob = true,
			float_style = "bright",
			inlay_hints_background = "none",
			---@param highlight_groups Highlights
			---@param palette Palette
			on_highlights = function(highlight_groups, palette) end,
			---@param palette Palette
			colours_override = function(palette) end,
		})
	end,
}
