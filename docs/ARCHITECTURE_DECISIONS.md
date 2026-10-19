# Cellar AI — registro de decisões de arquitetura

Status: **Aprovada**, **Direção adotada**, **Proposta**, **Adiada**, **Em aberto**. Datas exatas não confirmadas foram omitidas.

| ID | Status | Decisão / discussão | Razão / observação |
|---|---|---|---|
| ADR-001 | Aprovada | Produto orientado a memórias e experiências com vinho | Usuário escolheu explicitamente a visão B em vez de foco principal em gestão de adega. |
| ADR-002 | Aprovada | Slogan “Cada garrafa conta uma história.” | Identidade do produto. |
| ADR-003 | Direção adotada | Flutter e Dart, repositório Git, Firebase como backend planejado | Verificar implementação efetiva. |
| ADR-004 | Direção adotada | Domain-Driven Design com `EntityId`, `Entity`, `AggregateRoot` | Classes revisadas; manter domínio sem dependência de Flutter e banco. |
| ADR-005 | Direção adotada | `EntityId` implementado manualmente; arquivo Freezed órfão removido | Analyzer passou a zero erros e quatro warnings. |
| ADR-006 | Direção adotada | Separar catálogo mundial e posse pessoal | Preço, compra e quantidade não pertencem à descrição global de Wine. |
| ADR-007 | Proposta | Story como Aggregate Root das experiências | Definir invariantes; centralidade de produto não implica único agregado. |
| ADR-008 | Proposta | Bounded contexts Catalog, Cellar, Stories, Sommelier AI, User Profile | Fronteiras ainda não validadas. |
| ADR-009 | Direção adotada | Safra opcional; blends com múltiplas uvas; PackageSize somente volume | Suporte a vinhos e embalagens variados. "Safra opcional" refinada pela ADR-014. |
| ADR-010 | Adiada | WineVariant e WineLabel como abstrações separadas | Evitar antecipação de complexidade. |
| ADR-011 | Aprovada | Refinar Domain Blueprint antes de implementar Wine e Story | Reduzir retrabalho. |
| ADR-012 | Em aberto | Modelo de garrafas, lotes, Story-Wine e demais agregados | Exige sessão de modelagem. |
| ADR-013 | Aprovada | Hierarquia de documentação: fontes oficiais e histórico | Detalhada abaixo. Aprovada em 19/10/2026. |
| ADR-014 | Aprovada | Identidade de Wine: Produtor + Nome comercial + Safra (ano, NV ou desconhecida) | Detalhada abaixo. Aprovada em 19/10/2026. |
| ADR-015 | Aprovada | Catálogo de vinhos privado por usuário no MVP | Detalhada abaixo. Aprovada em 19/10/2026. |

## ADR-013 — Hierarquia de documentação

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** documentos anteriores (`VISION.md`, `DOMAIN_MAP.md`, `DOMAIN_MODEL.md`, `WINE_DOMAIN_MODEL.md`) contradiziam a ADR-001 e o Domain Blueprint, apresentando como decididos pontos ainda em aberto.
- **Decisão:** `DOMAIN_BLUEPRINT.md` é a fonte oficial do domínio; este registro é a fonte oficial das decisões; `VISION.md` contém somente a visão aprovada. Os rascunhos anteriores foram movidos para `docs/historico/`, com aviso no topo, e servem apenas como referência.
- **Alternativas consideradas:** apagar os rascunhos (perderia ideias úteis); atualizá-los todos (duplicaria conteúdo e manteria várias fontes).
- **Consequências:** ideias dos rascunhos voltam ao Blueprint somente como propostas, discutidas decisão a decisão. O histórico dos arquivos foi preservado com `git mv`.

## ADR-014 — Identidade de Wine

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** era preciso definir quando dois registros representam o mesmo vinho. `WINE_DOMAIN_MODEL.md` (histórico) já afirmava que a safra faz parte da identidade, mas o handoff tratava o tema como aberto. O modelo atual usava `null` tanto para vinho sem safra quanto para safra não registrada.
- **Decisão:**
  - Identidade de Wine = Produtor + Nome comercial + Safra.
  - Safras diferentes são Wines diferentes.
  - Safra tem três estados: ano, NV (sem safra declarada) e desconhecida. "Desconhecida" é ausência de informação e pode ser completada depois.
  - País, região, uvas, teor alcoólico e estilo são características, não identidade.
  - `PackageSize` não pertence a Wine, e sim à unidade física.
  - O agrupamento de todas as safras de um rótulo é calculado por Produtor + Nome, sem classe `WineLabel`.
- **Alternativas consideradas:** (B) safra fora da identidade, registrada na garrafa ou na história — misturaria avaliações de safras diferentes; (C) dois níveis Rótulo → Safra — mais fiel, porém adiado pela ADR-010.
- **Consequências:** o Value Object `Vintage` precisará representar os três estados; o `Wine` atual (protótipo) deixa de conter preço, quantidade e data de compra. Ficam em aberto a regra de comparação de nomes, o processo de completar safra desconhecida e o tratamento de produtor desconhecido (ver Blueprint, seção 5.1).

## ADR-015 — Catálogo privado por usuário no MVP

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** o catálogo pode ser individual ou compartilhado entre todos os usuários (modelo semelhante ao Vivino).
- **Decisão:** no MVP, cada usuário mantém seu próprio catálogo de vinhos.
- **Alternativas consideradas:** catálogo compartilhado desde o início — mais rico, mas exige deduplicação entre usuários, moderação e maior custo de infraestrutura.
- **Consequências:** a deduplicação fica restrita ao catálogo de cada usuário. O modelo de domínio não deve impedir a evolução para um catálogo compartilhado.

## Regra de manutenção
Registrar novas decisões com status, contexto, alternativas, consequências e data. Não transformar propostas em decisões aprovadas sem confirmação do responsável.
