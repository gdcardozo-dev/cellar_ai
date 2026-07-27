# Wine Domain Model

## Objetivo

Representar corretamente qualquer vinho produzido no mundo, independentemente de país, produtor, estilo ou legislação.

O modelo deve funcionar para:

- Vinhos tranquilos
- Espumantes
- Fortificados
- Vinhos de sobremesa
- Vinhos sem safra (NV)
- Vinhos naturais
- Vinhos de produção limitada
- Vinhos brasileiros, europeus, americanos, africanos, asiáticos e oceânicos

O domínio não deve depender de convenções específicas de um país ou produtor.

---

# O que é um Wine?

Wine representa um rótulo específico.

Exemplos:

- Catena Alta Malbec 2022
- Château Margaux 2018
- Penfolds Bin 389 2021
- Sassicaia 2020
- Dom Pérignon Vintage 2015

Um Wine descreve o produto.

Não descreve a posse do produto.

Preço pago, quantidade, localização e status pertencem à coleção do usuário.

---

# Princípios

1. O domínio representa a realidade do vinho.

2. O nome comercial nunca deve ser utilizado para inferir outras informações.

3. A safra faz parte da identidade do vinho.

4. Um vinho pode possuir uma ou mais uvas.

5. Percentuais de uvas são opcionais.

6. O catálogo deve permitir evolução sem alterar o modelo principal.