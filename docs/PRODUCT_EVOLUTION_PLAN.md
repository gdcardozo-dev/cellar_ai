# Cellar AI — Plano de evolução do produto

> Origem: aprendizados da catalogação real de 12 garrafas (novembro/2026).
> Decisões aprovadas em 18/11/2026: ADR-023 a ADR-029. Fonte oficial do modelo: `DOMAIN_BLUEPRINT.md`.

## 1. Princípios

- Simplicidade antes de complexidade.
- Experiência pessoal antes de rede social.
- Dados confiáveis antes de respostas aparentemente completas.
- Arquitetura sustentável antes de soluções improvisadas.
- Evolução incremental com testes.
- Produto comercialmente viável, escalável e com potencial de monetização.
- Cadastro com o mínimo de digitação e enriquecimento progressivo.

## 2. Decisões aprovadas

| Tema | Decisão | ADR |
|---|---|---|
| Prioridade | Histórias como identidade; Adega como porta de entrada; ambas no MVP | ADR-023 |
| Catálogo | Privado no MVP; sugestões de IA só após confirmação | ADR-024 |
| Presente | Presentear permite história opcional | ADR-025 |
| Compra | `Acquisition` agrupa lotes; valor total sem rateio automático | ADR-026 |
| Procedência | Sugerido × confirmado; identidade sempre confirmada | ADR-027 |
| IA | Fora do MVP; app funciona sem serviços externos de IA | ADR-028 |
| Pesquisa | Uva, região, produtor e rótulo; país associado à região | ADR-029 |

## 3. Classificação das funcionalidades

| MVP | Próxima versão | Evolução futura |
|---|---|---|
| Cadastro manual mínimo com enriquecimento progressivo | Cadastro assistido por IA (nome, foto do rótulo), sempre como sugestão | Catálogo global compartilhado |
| Adega: lotes, compras (inclusive em lote), estoque e baixas | Recomendação por ocasião e harmonização | Ranking de qualidade orientativo |
| Custo pago e estimativa de valor (manual, com fonte e confiança) | Relatório PDF A4 (funciona offline) | Valor de revenda e tendências |
| Janela de consumo (manual) e status por regras explícitas | Pesquisa por uva, região, produtor e rótulo | Recomendação aprendida por IA |
| Histórias com baixa no estoque | Painel completo com gráficos | Monetização (plano premium) |
| Painel simples: garrafas, países, tipos, custo e valor estimado | Classificação, prêmios, avaliações da crítica | — |

## 4. Roadmap

| Sprint | Entrega | Depende de |
|---|---|---|
| 0 (fechamento) | `Story`/`StoryWine`; `CellarLot` + `Acquisition` | — |
| 1 | Procedência, `MarketValuation`, `DrinkingWindow` e status de consumo, tipo de embalagem, código de lote, fixtures dos 12 vinhos com testes de aceite | Sprint 0 |
| 2 | Casos de uso (cadastrar vinho, registrar compra, registrar história, baixa avulsa, cadastrar pessoa) com armazenamento em memória | Sprint 1 |
| 3 | Decisão e implementação da persistência (Firebase × banco local) | Sprint 2 |
| 4 | Telas do MVP: adega, cadastro mínimo, história, painel simples | Sprint 3 e ambiente Flutter local |
| 5+ | Próxima versão: IA assistida, PDF, pesquisa, recomendações | MVP |

## 5. Dados de teste: 12 vinhos reais

- Ficam em `test/fixtures/` e são usados apenas por testes e por um futuro modo demonstração. **Nunca** são inseridos automaticamente na adega real.
- Campos desconhecidos permanecem vazios; nada é inventado.
- Safras: 001 e 012 → **desconhecida** (decisão de 18/11/2026). O código de lote de 012 (L2624426) nunca é usado para inferir safra.
- Estimativas de mercado: confiança baixa, fonte "estimativa histórica", data de referência desconhecida. Não são cotações atuais.
- Separação produtor × nome comercial de cada vinho: a confirmar com o responsável antes de montar os fixtures.

| ID | Vinho | Safra | País | Qtde. | Financeiro conhecido |
|---|---|---|---|---|---|
| 001 | Bojador Amphora Tinto | Desconhecida | Portugal | 1 | Compra conjunta 001–004: R$ 599,93 |
| 002 | Nieto Senetiner Single Vineyard Villa Blanca Malbec | 2023 | Argentina | 1 | Compra conjunta 001–004 |
| 003 | Tenuta Marcianella Vino Nobile di Montepulciano | 2023 | Itália | 1 | Compra conjunta 001–004 |
| 004 | Viña Cobos Bramare Luján de Cuyo Malbec | 2023 | Argentina | 1 | Compra conjunta 001–004 |
| 005 | CARMIM Reguengos Tinto | 2024 | Portugal | 1 | Estimativa R$ 55,00 |
| 006 | Aveleda Solos de Xisto Alvarinho | 2024 | Portugal | 1 | Pago € 7,00; estimativa R$ 230,00 |
| 007 | Luigi Bosca Insignia Malbec | 2022 | Argentina | 1 | Estimativa R$ 180,00 |
| 008 | Esporão Monte Velho Tinto | 2024 | Portugal | 1 | Estimativa R$ 75,00 |
| 009 | Cartuxa EA Tinto | 2023 | Portugal | 1 | Estimativa R$ 75,00 |
| 010 | Iron Maiden Eddie's Blend Darkest Red | 2024 | Portugal | 1 | Pago € 13,00; estimativa R$ 190,00 |
| 011 | Casillero del Diablo Reserva Cabernet Sauvignon | 2024 | Chile | 1 | Estimativa R$ 60,00 |
| 012 | Casillero del Diablo Devil's Carnaval Spectacular Cabernet | Desconhecida | Chile | 1 | Estimativa R$ 60,00; código de lote L2624426 |

## 6. Critérios de aceite (viram testes)

- O painel mostra 12 garrafas: Portugal 6, Argentina 3, Chile 2, Itália 1.
- Custo pago apresentado por moeda, sem conversão e sem rateio: R$ 599,93 e € 20,00.
- Estimativa de reposição dos vinhos 005–012: R$ 925,00; 001–004 sem estimativa.
- Vinhos 001 e 012 aparecem como "safra desconhecida", nunca com um ano.
- Registrar uma história com o vinho 007 deixa 0 disponível; nova tentativa é recusada.
- Janela de consumo sugerida aparece marcada como sugestão até ser confirmada.
- Vinho sem janela de consumo tem status "Sem informação".
- Painel e relatório funcionam sem serviços de IA.

## 7. Riscos e premissas

- Dados inventados por IA: mitigado por procedência, confirmação da identidade e confiança visível.
- Moedas sem conversão: totais apresentados por moeda; conversão exige cotação datada e fonte (decisão futura).
- Dados de terceiros (preços, avaliações): avaliar licença e termos de uso antes de integrar.
- Escopo × tempo de aprendizado: passos pequenos verificados pela CI.
- LGPD: ADR-017 e ADR-022 continuam válidas.

## 8. Decisões futuras pendentes

- Limiares das regras de status de consumo.
- Tipo de embalagem (lista).
- Limite de agregado entre `Acquisition` e `CellarLot`.
- Persistência: Firebase × banco local.
- Conversão de moedas.
- Público-alvo e modelo de negócio.
