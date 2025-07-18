return {
	"Saghen/blink.cmp",
	dependencies = {
		-- other dependencies...
		"jdrupal-dev/css-vars.nvim",
	},
	opts = {
		-- your blink.cmp config...
		providers = {
			css_vars = {
				name = "css-vars",
				module = "css-vars.blink",
				opts = {
					-- WARNING: The search is not optimized to look for variables in JS files.
					-- If you change the search_extensions you might get false positives and weird completion results.
					search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
				},
			},
		},
	},
}
