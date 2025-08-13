return {
    -- nvim-orgmode
    {
        "nvim-orgmode/orgmode",
        event = "VeryLazy",
        config = function()
            require("orgmode").setup({
                org_agenda_files = "~/orgfiles/**/*",
                org_default_notes_file = "~/orgfiles/refile.org",
            })
        end,
    },

    -- org-roam.nvim
    {
        "chipsenkbeil/org-roam.nvim",
        tag = "0.1.1",
        dependencies = { "nvim-orgmode/orgmode" }, -- Reference the already loaded orgmode plugin
        config = function()
            require("org-roam").setup({
                directory = "~/org_roam_files",
                -- Optional: If you have other specific org files outside of org_roam_files
                -- that you want org-roam to be aware of, list them here.
                -- Otherwise, you might not need this.
                org_files = {
                    -- "~/another_org_dir",
                    -- "~/some/folder/*.org",
                    -- "~/a/single/org_file.org",
                },
            })
        end,
    },

    -- telescope-orgmode.nvim
    {
        "nvim-orgmode/telescope-orgmode.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-orgmode/orgmode",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("telescope").load_extension("orgmode")

            vim.keymap.set(
                "n",
                "<leader>r",
                require("telescope").extensions.orgmode.refile_heading,
                { desc = "Orgmode: Refile Heading" }
            )
            vim.keymap.set(
                "n",
                "<leader>fh",
                require("telescope").extensions.orgmode.search_headings,
                { desc = "Orgmode: Search Headings" }
            )
            vim.keymap.set(
                "n",
                "<leader>li",
                require("telescope").extensions.orgmode.insert_link,
                { desc = "Orgmode: Insert Link" }
            )
        end,
    },

    -- org-bullets.nvim
    {
        "akinsho/org-bullets.nvim",
        event = "VeryLazy",
        config = function()
            require("org-bullets").setup({
                concealcursor = false,
                symbols = {
                    list = "•",
                    -- Consolidated headlines configuration
                    headlines = { "◉", "○", "✸", "✿" },
                    checkboxes = {
                        half = { "", "@org.checkbox.halfchecked" },
                        done = { "✓", "@org.keyword.done" },
                        todo = { "˟", "@org.keyword.todo" },
                    },
                },
            })
        end,
    },

    -- headlines.nvim
    -- {
    --     "lukas-reineke/headlines.nvim",
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     config = function()
    --         require("headlines").setup({
    --             -- Markdown configuration
    --             markdown = {
    --                 query = vim.treesitter.parse_query(
    --                     "markdown",
    --                     [[
    --                     (atx_heading [
    --                         (atx_h1_marker)
    --                         (atx_h2_marker)
    --                         (atx_h3_marker)
    --                         (atx_h4_marker)
    --                         (atx_h5_marker)
    --                         (atx_h6_marker)
    --                     ] @headline)
    --
    --                     (thematic_break) @dash
    --
    --                     (fenced_code_block) @codeblock
    --
    --                     (block_quote_marker) @quote
    --                     (block_quote (paragraph (inline (block_continuation) @quote)))
    --                     (block_quote (paragraph (block_continuation) @quote))
    --                     (block_quote (block_continuation) @quote)
    --                     ]]
    --                 ),
    --                 headline_highlights = { "Headline" },
    --                 bullet_highlights = {
    --                     "@text.title.1.marker.markdown",
    --                     "@text.title.2.marker.markdown",
    --                     "@text.title.3.marker.markdown",
    --                     "@text.title.4.marker.markdown",
    --                     "@text.title.5.marker.markdown",
    --                     "@text.title.6.marker.markdown",
    --                 },
    --                 bullets = { "◉", "○", "✸", "✿" },
    --                 codeblock_highlight = "CodeBlock",
    --                 dash_highlight = "Dash",
    --                 dash_string = "-",
    --                 quote_highlight = "Quote",
    --                 quote_string = "┃",
    --                 fat_headlines = true,
    --                 fat_headline_upper_string = "▄",
    --                 fat_headline_lower_string = "▀",
    --             },
    --             -- Rmd configuration (can often just use markdown)
    --             rmd = {
    --                 query = vim.treesitter.parse_query(
    --                     "markdown", -- Assuming Rmd uses markdown treesitter parser
    --                     [[
    --                     (atx_heading [
    --                         (atx_h1_marker)
    --                         (atx_h2_marker)
    --                         (atx_h3_marker)
    --                         (atx_h4_marker)
    --                         (atx_h5_marker)
    --                         (atx_h6_marker)
    --                     ] @headline)
    --
    --                     (thematic_break) @dash
    --
    --                     (fenced_code_block) @codeblock
    --
    --                     (block_quote_marker) @quote
    --                     (block_quote (paragraph (inline (block_continuation) @quote)))
    --                     (block_quote (paragraph (block_continuation) @quote))
    --                     (block_quote (block_continuation) @quote)
    --                     ]]
    --                 ),
    --                 treesitter_language = "markdown", -- Explicitly set if different
    --                 headline_highlights = { "Headline" },
    --                 bullet_highlights = {
    --                     "@text.title.1.marker.markdown",
    --                     "@text.title.2.marker.markdown",
    --                     "@text.title.3.marker.markdown",
    --                     "@text.title.4.marker.markdown",
    --                     "@text.title.5.marker.markdown",
    --                     "@text.title.6.marker.markdown",
    --                 },
    --                 bullets = { "◉", "○", "✸", "✿" },
    --                 codeblock_highlight = "CodeBlock",
    --                 dash_highlight = "Dash",
    --                 dash_string = "-",
    --                 quote_highlight = "Quote",
    --                 quote_string = "┃",
    --                 fat_headlines = true,
    --                 fat_headline_upper_string = "▄",
    --                 fat_headline_lower_string = "▀",
    --             },
    --             -- Norg configuration
    --             norg = {
    --                 query = vim.treesitter.parse_query(
    --                     "norg",
    --                     [[
    --                     [
    --                         (heading1_prefix)
    --                         (heading2_prefix)
    --                         (heading3_prefix)
    --                         (heading4_prefix)
    --                         (heading5_prefix)
    --                         (heading6_prefix)
    --                     ] @headline
    --
    --                     (weak_paragraph_delimiter) @dash
    --                     (strong_paragraph_delimiter) @doubledash
    --
    --                     ([(ranged_tag
    --                         name: (tag_name) @_name
    --                         (#eq? @_name "code")
    --                     )
    --                     (ranged_verbatim_tag
    --                         name: (tag_name) @_name
    --                         (#eq? @_name "code")
    --                     )] @codeblock (#offset! @codeblock 0 0 1 0))
    --
    --                     (quote1_prefix) @quote
    --                     ]]
    --                 ),
    --                 headline_highlights = { "Headline" },
    --                 bullet_highlights = {
    --                     "@neorg.headings.1.prefix",
    --                     "@neorg.headings.2.prefix",
    --                     "@neorg.headings.3.prefix",
    --                     "@neorg.headings.4.prefix",
    --                     "@neorg.headings.5.prefix",
    --                     "@neorg.headings.6.prefix",
    --                 },
    --                 bullets = { "◉", "○", "✸", "✿" },
    --                 codeblock_highlight = "CodeBlock",
    --                 dash_highlight = "Dash",
    --                 dash_string = "-",
    --                 doubledash_highlight = "DoubleDash",
    --                 doubledash_string = "=",
    --                 quote_highlight = "Quote",
    --                 quote_string = "┃",
    --                 fat_headlines = true,
    --                 fat_headline_upper_string = "▄",
    --                 fat_headline_lower_string = "▀",
    --             },
    --             -- Org configuration
    --             org = {
    --                 query = vim.treesitter.parse_query(
    --                     "org",
    --                     [[
    --                     (headline (stars) @headline)
    --
    --                     (
    --                         (expr) @dash
    --                         (#match? @dash "^-----+$")
    --                     )
    --
    --                     (block
    --                         name: (expr) @_name
    --                         (#match? @_name "(SRC|src)")
    --                     ) @codeblock
    --
    --                     (paragraph . (expr) @quote
    --                         (#eq? @quote ">")
    --                     )
    --                     ]]
    --                 ),
    --                 headline_highlights = { "Headline" },
    --                 bullet_highlights = {
    --                     "@org.headline.level1",
    --                     "@org.headline.level2",
    --                     "@org.headline.level3",
    --                     "@org.headline.level4",
    --                     "@org.headline.level5",
    --                     "@org.headline.level6",
    --                     "@org.headline.level7",
    --                     "@org.headline.level8",
    --                 },
    --                 bullets = { "◉", "○", "✸", "✿" },
    --                 codeblock_highlight = "CodeBlock",
    --                 dash_highlight = "Dash",
    --                 dash_string = "-",
    --                 quote_highlight = "Quote",
    --                 quote_string = "┃",
    --                 fat_headlines = true,
    --                 fat_headline_upper_string = "▄",
    --                 fat_headline_lower_string = "▀",
    --             },
    --         })
    --     end,
    -- },
}
