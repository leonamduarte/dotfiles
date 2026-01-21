return {
  "saghen/blink.cmp",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = {
      list = {
        selection = {
          -- 1. Quando 'false', o menu abre sem selecionar o primeiro item
          preselect = false,

          -- 2. Quando 'true', insere o texto automaticamente ao navegar.
          -- Se você prefere apenas ver a seleção e dar <Tab> ou <CR> para confirmar,
          -- pode querer deixar como 'false' também, mas 'true' costuma ser o padrão confortável.
          auto_insert = true,
        },
      },
    },

    -- Garantia dos Keymaps
    keymap = {
      -- O preset 'enter' ou 'default' geralmente já mapeia C-n,
      -- mas aqui garantimos que ele faça a seleção do próximo item.
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      -- Ao pressionar Seta Cima/Baixo, ignora o menu e move o cursor no texto
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
    },
  },
}
