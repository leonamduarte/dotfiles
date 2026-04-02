---
name: 30-test-component
description: Gera e executa testes de componentes React Native
compatibility: opencode
when_to_use: Para testar componentes sem emulador usando React Native Testing Library
allowed-tools: ["Read", "Write", "Bash", "Glob"]
model: inherit
user-invocable: true
context: inline
---

## Goal

Gerar e executar testes de componentes React Native usando Testing Library, sem precisar de device ou emulador.

## When to use

- Componentes React Native (View, Text, Button, etc.)
- Interacoes do usuario (tap, input, scroll)
- Renderizacao condicional
- Props e estado
- Accessibility labels

## Dependencies Check

Verifique instalacao:
- `@testing-library/react-native` - obrigatorio
- `jest` - obrigatorio
- `react-test-renderer` - peer dependency

Se faltando: "Instale com: npm install -D @testing-library/react-native react-test-renderer"

## Workflow

1. **Analise o componente**
   - Props aceitas
   - Estados (visivel/invisivel, habilitado/desabilitado)
   - Eventos (onPress, onChangeText, etc.)
   - Condicoes de renderizacao

2. **Gere o teste de componente**
   - Arquivo: `{Componente}.test.tsx`
   - Use render, fireEvent, screen de RNTL
   - Teste comportamento, nao implementacao

3. **Casos de teste**
   - Renderizacao basica
   - Interacoes (tap, input)
   - Estados (loading, error, empty)
   - Props diferentes

4. **Execute**
   - `jest {arquivo}` ou `npm test -- {arquivo}`

## Exemplo de Output

```typescript
// components/ResumoGasto.test.tsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react-native';
import { ResumoGasto } from './ResumoGasto';

describe('ResumoGasto', () => {
  it('exibe total corretamente', () => {
    render(<ResumoGasto total={150.0} />);
    expect(screen.getByText('R$ 150,00')).toBeTruthy();
  });

  it('exibe mensagem quando total e zero', () => {
    render(<ResumoGasto total={0} />);
    expect(screen.getByText('Nenhum gasto registrado')).toBeTruthy();
  });

  it('chama onPress quando botao e clicado', () => {
    const mockPress = jest.fn();
    render(<ResumoGasto total={150.0} onPress={mockPress} />);
    
    fireEvent.press(screen.getByText('Ver detalhes'));
    expect(mockPress).toHaveBeenCalled();
  });

  it('desabilita botao quando disabled prop e true', () => {
    render(<ResumoGasto total={150.0} disabled />);
    const button = screen.getByText('Ver detalhes');
    expect(button.props.disabled).toBe(true);
  });
});
```

## Expected Input

- Componente React Native a testar
- Lista de props e comportamentos esperados
- Cenarios de edge case (loading, error, vazio)

## Expected Output

- Arquivo `.test.tsx` com testes de componente
- Cobertura de render, interacao e estados
- Resultado da execucao

## Notes

- Use `getByText`, `getByTestId`, `getByAccessibilityLabel` para queries
- Prefira `screen` em vez de desestruturar render()
- Teste comportamento visivel ao usuario
- Nao teste detalhes de implementacao interna (styled-components, etc)
