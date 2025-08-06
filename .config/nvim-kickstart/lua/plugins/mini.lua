return {
	{
		"echasnovski/mini.nvim",
		version = "*", -- A melhor prática para garantir a versão mais recente
		config = function()
			-- Define a tecla leader. É uma boa prática fazer isso uma vez no seu init.lua.
			-- vim.g.mapleader = ' '

			-- Configuração do mini.ai
			-- A opção `n_lines` é útil para performance em arquivos grandes.
			require("mini.ai").setup({ n_lines = 500 })

			-- Configuração do mini.surround
			-- Mapeamentos padrão são geralmente mais fáceis de lembrar.
			-- Aqui, usamos os mapeamentos que você sugeriu, mas eles são longos.
			require("mini.surround").setup({
				mappings = {
					add = "gsa",
					delete = "gsd",
					find = "gsf",
					find_left = "gsF",
					highlight = "gsh",
					replace = "gsr",
					update_n_lines = "gsn",
				},
			})

			-- Configuração do mini.move
			-- Mapeamentos alternativos para evitar conflito com H, L, J, K do Neovim.
			-- Usamos "<leader>" para evitar conflitos.
			-- 'a' para esquerda, 'd' para baixo, 's' para cima, 'f' para direita.
			require("mini.move").setup({
				mappings = {
					left = "<leader>a",
					right = "<leader>f",
					down = "<leader>d",
					up = "<leader>s",
					-- Não é necessário remapear 'line' se você já tem os movimentos básicos
					-- line_left = '',
					-- line_right = '',
					-- line_down = '',
					-- line_up = '',
				},
			})

			-- Configuração do mini.comment
			-- O plugin já oferece uma forma intuitiva de comentar. Não é necessário criar keymaps duplicados.
			-- O atalho padrão 'gc' já é muito eficaz e funciona em modo normal e visual.
			require("mini.comment").setup({
				-- Para comentar em modo visual, basta selecionar o texto e digitar 'gc'.
				-- Em modo normal, 'gcc' para a linha atual ou 'gc' + movimento para um trecho específico.
				mappings = {
					comment = "gc", -- Usa 'gc' como atalho principal
					comment_line = "gcc", -- Atalho para comentar a linha atual
					textobject = "gct",
				},
			})

			-- Configuração do mini.ai
			-- Comandos para mover dentro de um "AI" (objeto de texto inteligente).
			require("mini.ai").setup()

			-- O mini.icons não existe no mini.nvim, então o código foi removido para evitar erros.
			-- Para ícones, use um plugin como 'nvim-web-devicons'.
			-- Por exemplo:
			-- require('nvim-web-devicons').setup()
		end,
	},
}
