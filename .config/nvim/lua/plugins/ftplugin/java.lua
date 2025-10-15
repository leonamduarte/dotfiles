-- ~/.config/nvim/ftplugin/java.lua
local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
  vim.notify("nvim-jdtls não encontrado", vim.log.levels.WARN)
  return
end

-- Descobre a raiz do projeto
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
  return
end

-- Workspace do jdtls (um por projeto)
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

-- Bundles (Debug e Test) a partir do Mason
local mason_ok, mason_registry = pcall(require, "mason-registry")
local bundles = {}
if mason_ok then
  if mason_registry.is_installed("java-debug-adapter") then
    local pkg = mason_registry.get_package("java-debug-adapter")
    local path = pkg:get_install_path()
    local jar = vim.fn.glob(path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1)
    if jar and #jar > 0 then
      table.insert(bundles, jar)
    end
  end
  if mason_registry.is_installed("java-test") then
    local pkg = mason_registry.get_package("java-test")
    local path = pkg:get_install_path()
    -- Todos os .jar do java-test
    local jars = vim.split(vim.fn.glob(path .. "/extension/server/*.jar", 1), "\n", { trimempty = true })
    vim.list_extend(bundles, jars)
  end
end

-- Capacidades (completion do nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)

-- Detecta se o projeto usa Gradle ou Maven
local is_gradle = (vim.fn.filereadable(root_dir .. "/gradlew") == 1)
  or (vim.fn.filereadable(root_dir .. "/build.gradle") == 1)

-- Comandos de build/test simples (fallback no terminal)
local function build_cmd()
  return is_gradle and "./gradlew build -x test" or "mvn -q -DskipTests compile"
end

-- Configuração principal do jdtls
local config = {
  cmd = { "jdtls", "--jvm-arg=-Xms256m" },
  root_dir = root_dir,
  capabilities = capabilities,
  init_options = {
    bundles = bundles, -- habilita DAP e testes quando os bundles estão instalados
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = { favoriteStaticMembers = { "org.junit.jupiter.api.Assertions.*", "org.mockito.Mockito.*" } },
      sources = { organizeImports = { starThreshold = 999, staticStarThreshold = 999 } },
      configuration = { updateBuildConfiguration = "interactive" },
      format = { enabled = true }, -- usa o formatter padrão do Eclipse
      codeGeneration = {
        toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
      },
    },
  },
  flags = { allow_incremental_sync = true },
}

-- (Opcional) Se seu projeto usa Lombok, descomente e ajuste o caminho:
-- table.insert(config.cmd, "--jvm-arg=-javaagent:/caminho/para/lombok.jar")

-- on_attach: mapeia teclas e integra DAP/Test
config.on_attach = function(client, bufnr)
  -- Atalhos padrão LSP do LazyVim já existem, aqui só os de Java extras
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- Comandos jdtls úteis
  map("n", "<leader>jo", jdtls.organize_imports, "Java: Organize Imports")
  map("n", "<leader>jv", jdtls.extract_variable, "Java: Extract Variable")
  map("x", "<leader>jv", function()
    jdtls.extract_variable(true)
  end, "Java: Extract Variable (vis)")
  map("n", "<leader>jm", jdtls.extract_method, "Java: Extract Method")
  map("x", "<leader>jm", function()
    jdtls.extract_method(true)
  end, "Java: Extract Method (vis)")
  map("n", "<leader>jc", function()
    vim.cmd("split | terminal " .. build_cmd())
  end, "Java: Compilar (Maven/Gradle)")

  -- Testes (requer bundles do java-test)
  map("n", "<leader>tt", jdtls.test_nearest_method, "Test: Método (nearest)")
  map("n", "<leader>tT", jdtls.test_class, "Test: Classe")
  map("n", "<leader>tr", jdtls.test_repeat, "Test: Repetir último")

  -- Debug (DAP) – configura automaticamente mainClass
  pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
  pcall(jdtls.setup_additional_capabilities)

  -- Atalhos DAP básicos (LazyVim já tem, mas garantimos aqui)
  local dap_ok, dap = pcall(require, "dap")
  if dap_ok then
    map("n", "<F5>", dap.continue, "DAP: Continue")
    map("n", "<F10>", dap.step_over, "DAP: Step Over")
    map("n", "<F11>", dap.step_into, "DAP: Step Into")
    map("n", "<F12>", dap.step_out, "DAP: Step Out")
    map("n", "<leader>db", dap.toggle_breakpoint, "DAP: Toggle Breakpoint")
    map("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Cond: "))
    end, "DAP: Breakpoint cond.")
    map("n", "<leader>dr", dap.repl.open, "DAP: REPL")
  end
end

-- Inicia ou anexa ao servidor
config.workspace_folders = { workspace_dir }
config.cmd_env = { JDTLS_JVM_ARGS = "" } -- gancho p/ args extras via env se quiser
config.settings.java.inlayHints = { parameterNames = { enabled = "all" } } -- dicas de parâmetro

-- Cria a pasta do workspace se não existir
vim.fn.mkdir(workspace_dir, "p")

-- Finalmente, inicia
jdtls.start_or_attach(config)

-- Opcional: formatação on-save (ajuste se usa conform/formatter do LazyVim)
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function()
    -- Use o format do LSP
    vim.lsp.buf.format({ async = false })
  end,
})
