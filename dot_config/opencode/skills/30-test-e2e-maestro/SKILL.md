---
name: 30-test-e2e-maestro
description: Gera e executa testes E2E com Maestro para Expo
compatibility: opencode
when_to_use: Para simular usuario real em fluxos criticos do app
allowed-tools: ["Read", "Write", "Bash", "Glob"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Gerar e executar testes end-to-end com Maestro para React Native/Expo, simulando interacoes reais do usuario.

## When to use

- Fluxos criticos de usuario (login, compra, cadastro)
- Navegacao entre telas
- Integracao com recursos nativos (camera, GPS, notificacoes)
- Testes em devices reais
- Smoke tests de release

## Dependencies Check

Verifique instalacao:
- `maestro` CLI - obrigatorio
- App compilado (APK para Android, IPA para iOS) ou Expo Dev Client

Se faltando Maestro: "Instale Maestro: curl -fsSL "https://get.maestro.mobile.dev" | bash"
Se faltando app: "Compile o app primeiro: expo prebuild && eas build --local"

## Workflow

1. **Mapeie o fluxo do usuario**
   - Tela inicial
   - Acoes (tap, input, swipe)
   - Verificacoes (assertVisible, assertNotVisible)
   - Fluxos alternativos (erros, voltar)

2. **Gere o flow YAML**
   - Arquivo: `flows/{fluxo}.yaml`
   - Use IDs de teste (testID) para elementos
   - Comandos: tapOn, inputText, assertVisible, swipe

3. **Organize os flows**
   - `flows/login.yaml`
   - `flows/scan_nfce.yaml`
   - `flows/compra_completa.yaml`

4. **Execute**
   - `maestro test flows/login.yaml`
   - ou: `maestro test flows/` (roda todos)

## Exemplo de Output

```yaml
# flows/scan_nfce.yaml
appId: com.seuapp.expo
tags:
  - critical
  - nfce
---
- launchApp
- assertVisible: "Escanear NFC-e"

- tapOn: "Escanear NFC-e"
- assertVisible: "Aproxime o celular do QR code"

- tapOn: 
    id: "camera-permission-allow"
- assertVisible: "Camera ativa"

# Simula scan (em teste pode usar mock)
- tapOn: 
    id: "mock-scan-button"
    optional: true

- assertVisible: "Nota adicionada com sucesso"
- assertVisible: "Total: R$"

- tapOn: "Ver detalhes"
- assertVisible: "Itens da compra"
```

## Expected Input

- Fluxo de usuario a automatizar
- IDs de elementos (testID) disponiveis
- Screenshots ou descricao das telas
- Cenarios de sucesso e erro

## Expected Output

- Arquivo `.yaml` do flow Maestro
- Page objects/helpers se necessario
- Relatorio de execucao (pass/fail/passos)

## Notes

- Adicione `testID` aos componentes no codigo RN
- Use `optional: true` para elementos que podem nao aparecer
- Tags ajudam a rodar grupos de testes: `maestro test --include-tags=critical`
- Grave flows com `maestro record` para facilitar
- CI: rode em emulador ou device farm
