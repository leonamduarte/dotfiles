---
name: test-jest-integration
description: Gera e executa testes de integracao com Jest e mocks
compatibility: opencode
when_to_use: Para testar fluxos completos com APIs e servicos mockados
allowed-tools: ["Read", "Write", "Bash", "Glob"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Gerar e executar testes de integracao que validam fluxos completos usando mocks de API (MSW ou manual).

## When to use

- Fluxos que envolvem multiplas camadas (UI -> service -> API)
- Chamadas a APIs externas
- Operacoes com banco de dados
- File system operations
- Testar cenarios de erro de rede/servico

## Dependencies Check

Verifique instalacao:
- `jest` - obrigatorio
- `msw` (Mock Service Worker) - recomendado para HTTP mocks
- `node-mocks-http` - alternativa para APIs

Se faltando: "Instale com: npm install -D msw @types/msw node-mocks-http"

## Workflow

1. **Identifique o fluxo**
   - Entrada: acao do usuario ou evento
   - Processo: chamadas de servico, transformacoes
   - Saida: estado final ou resposta

2. **Configure mocks**
   - MSW: setup de handlers para rotas HTTP
   - ou: mock manual de funcoes/modulos

3. **Gere o teste de integracao**
   - Arquivo: `{fluxo}.integration.test.ts`
   - Setup: beforeAll/afterAll para mocks
   - Testes: cenarios sucesso e erro

4. **Execute**
   - `jest --config jest.integration.config.js` ou
   - `npm run test:integration`

## Exemplo de Output

```typescript
// services/nfce.integration.test.ts
import { server } from '../mocks/server';
import { rest } from 'msw';
import { fetchNFCe } from './nfce';

beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('fetchNFCe integracao', () => {
  it('busca e persiste NFC-e com sucesso', async () => {
    server.use(
      rest.get('https://sefaz.gov.br/nfce/:id', (req, res, ctx) => {
        return res(ctx.json(mockNFCeResponse));
      })
    );

    const result = await fetchNFCe('123456789');
    
    expect(result.id).toBe('123456789');
    expect(result.total).toBe(150.0);
    expect(result.items).toHaveLength(3);
  });

  it('lanca erro quando SEFAZ retorna 404', async () => {
    server.use(
      rest.get('https://sefaz.gov.br/nfce/:id', (req, res, ctx) => {
        return res(ctx.status(404));
      })
    );

    await expect(fetchNFCe('invalido')).rejects.toThrow('NFC-e nao encontrada');
  });
});
```

## Expected Input

- Fluxo ou servico a testar
- APIs ou dependencias externas envolvidas
- Cenarios de sucesso e erro esperados

## Expected Output

- Arquivo `.integration.test.ts` com mocks
- Configuracao de MSW/server se necessario
- Resultado da execucao dos testes

## Notes

- Teste o fluxo completo, nao implementacoes internas
- Mocks devem ser realisticos (nao retornem data sempre igual)
- Limpe estado entre testes (resetHandlers)
- Documente quais servicos externos estao mockados
