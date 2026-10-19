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
| ADR-009 | Direção adotada | Safra opcional; blends com múltiplas uvas; PackageSize somente volume | Suporte a vinhos e embalagens variados. |
| ADR-010 | Adiada | WineVariant e WineLabel como abstrações separadas | Evitar antecipação de complexidade. |
| ADR-011 | Aprovada | Refinar Domain Blueprint antes de implementar Wine e Story | Reduzir retrabalho. |
| ADR-012 | Em aberto | Modelo de garrafas, lotes, Story-Wine e demais agregados | Exige sessão de modelagem. |
| ADR-013 | Aprovada | Hierarquia de documentação: fontes oficiais e histórico | Detalhada abaixo. Aprovada em 19/10/2026. |

## ADR-013 — Hierarquia de documentação

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** documentos anteriores (`VISION.md`, `DOMAIN_MAP.md`, `DOMAIN_MODEL.md`, `WINE_DOMAIN_MODEL.md`) contradiziam a ADR-001 e o Domain Blueprint, apresentando como decididos pontos ainda em aberto.
- **Decisão:** `DOMAIN_BLUEPRINT.md` é a fonte oficial do domínio; este registro é a fonte oficial das decisões; `VISION.md` contém somente a visão aprovada. Os rascunhos anteriores foram movidos para `docs/historico/`, com aviso no topo, e servem apenas como referência.
- **Alternativas consideradas:** apagar os rascunhos (perderia ideias úteis); atualizá-los todos (duplicaria conteúdo e manteria várias fontes).
- **Consequências:** ideias dos rascunhos voltam ao Blueprint somente como propostas, discutidas decisão a decisão. O histórico dos arquivos foi preservado com `git mv`.

## Regra de manutenção
Registrar novas decisões com status, contexto, alternativas, consequências e data. Não transformar propostas em decisões aprovadas sem confirmação do responsável.
