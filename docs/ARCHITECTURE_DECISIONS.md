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
| ADR-007 | Aprovada | Story como Aggregate Root das experiências | Confirmada pela ADR-016 e ADR-019; Story não é o único agregado do sistema. |
| ADR-008 | Aprovada | Cinco bounded contexts: Catálogo, Adega, Histórias, Sommelier AI e Perfil | Confirmada pela ADR-019 em 12/11/2026; contextos conceituais. |
| ADR-009 | Direção adotada | Safra opcional; blends com múltiplas uvas; PackageSize somente volume | Suporte a vinhos e embalagens variados. "Safra opcional" refinada pela ADR-014. |
| ADR-010 | Adiada | WineVariant e WineLabel como abstrações separadas | Evitar antecipação de complexidade. |
| ADR-011 | Aprovada | Refinar Domain Blueprint antes de implementar Wine e Story | Reduzir retrabalho. |
| ADR-012 | Resolvida | Modelo de garrafas, lotes, Story-Wine e demais agregados | Resolvida pelas ADR-016, ADR-017 e ADR-019. |
| ADR-013 | Aprovada | Hierarquia de documentação: fontes oficiais e histórico | Detalhada abaixo. Aprovada em 19/10/2026. |
| ADR-014 | Aprovada | Identidade de Wine: Produtor + Nome comercial + Safra (ano, NV ou desconhecida) | Detalhada abaixo. Aprovada em 19/10/2026. |
| ADR-015 | Aprovada | Catálogo de vinhos privado por usuário no MVP | Detalhada abaixo. Aprovada em 19/10/2026. Complementada pela ADR-024. |
| ADR-016 | Aprovada | Story referencia vinhos por StoryWine; notas do momento e do vinho; ao menos um vinho por Story | Detalhada abaixo. Aprovada em 19/10/2026. |
| ADR-017 | Aprovada | Person e Place como entidades; fotos e pratos como Value Objects; notas de 1 a 5 | Detalhada abaixo. Aprovada em 19/10/2026. |
| ADR-018 | Aprovada | Commits de documentação de decisões aprovadas dispensam nova aprovação | Registrada no `CLAUDE.md`. Aprovada em 19/10/2026. |
| ADR-019 | Aprovada | Limites de agregados, CellarLot e consumo sempre com Story | Detalhada abaixo. Aprovada em 12/11/2026. Revisada parcialmente pelas ADR-025 e ADR-026. |
| ADR-020 | Aprovada | Padrões técnicos: DomainException, Money em centavos com moeda, Vintage como sealed class | Detalhada abaixo. Aprovada em 12/11/2026. |
| ADR-021 | Aprovada | Tipo do vinho como lista única opcional; regras de composição de uvas | Detalhada abaixo. Aprovada em 13/11/2026. |
| ADR-022 | Aprovada | Person identificada pelo nome normalizado; Place com tipo e cidade opcionais | Detalhada abaixo. Aprovada em 14/11/2026. |
| ADR-023 | Aprovada | Prioridade do produto: Histórias como identidade e Adega como porta de entrada, ambas no MVP | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-024 | Aprovada | Catálogo privado no MVP; sugestões de IA só entram após confirmação do usuário | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-025 | Aprovada | Presentear uma garrafa permite história opcional (revisa parcialmente a ADR-019) | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-026 | Aprovada | Acquisition: compra que agrupa lotes, com valor total e sem rateio automático (revisa parcialmente a ADR-019) | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-027 | Aprovada | Procedência dos dados: sugerido × confirmado; identidade sempre confirmada | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-028 | Aprovada | IA fora do MVP; app funciona sem serviços externos de IA | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-029 | Aprovada | Ordem de preferência de pesquisa: uva, região, produtor e rótulo; país associado à região | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-030 | Aprovada | Regras da Story: título opcional, destino bebido/presenteado, sem data futura, troca de vinho só fora da adega | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-031 | Aprovada | CellarLot e Acquisition como Aggregate Roots separados; lote referencia a compra pelo id | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-032 | Aprovada | Janela de consumo com status por regras explícitas; MarketValuation com histórico | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-033 | Aprovada | Tipo de embalagem e código de lote do fabricante no CellarLot; procedência no Wine adiada para a Sprint 2 | Detalhada abaixo. Aprovada em 18/11/2026. |
| ADR-034 | Aprovada | Pastas por camada: domínio, aplicação e infraestrutura; repositórios como contratos no domínio | Detalhada abaixo. Aprovada em 18/11/2026. |

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
- **Consequências:** o Value Object `Vintage` precisará representar os três estados; o `Wine` atual (protótipo) deixa de conter preço, quantidade e data de compra. Regras complementares aprovadas em 19/10/2026 (ver Blueprint, seção 5.1): comparação de nomes ignora maiúsculas, acentos e espaços extras; ao completar uma safra desconhecida, atualiza-se a referência da experiência, não o Wine compartilhado; produtor desconhecido é representado por "Produtor Desconhecido", com nome comercial descritivo.

## ADR-015 — Catálogo privado por usuário no MVP

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** o catálogo pode ser individual ou compartilhado entre todos os usuários (modelo semelhante ao Vivino).
- **Decisão:** no MVP, cada usuário mantém seu próprio catálogo de vinhos.
- **Alternativas consideradas:** catálogo compartilhado desde o início — mais rico, mas exige deduplicação entre usuários, moderação e maior custo de infraestrutura.
- **Consequências:** a deduplicação fica restrita ao catálogo de cada usuário. O modelo de domínio não deve impedir a evolução para um catálogo compartilhado.

## ADR-016 — Story referencia vinhos por StoryWine

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** o protótipo de `Story` guardava apenas uma lista de ids de vinho. Era preciso suportar experiências em casa (garrafa da adega), em restaurantes, com presentes abertos na hora e em degustações com vários vinhos.
- **Decisão:**
  - A Story contém uma lista de `StoryWine` ("vinho da história"), parte do agregado Story.
  - Cada `StoryWine` referencia um Wine (obrigatório), opcionalmente a garrafa da adega de onde veio, e opcionalmente a impressão do usuário (nota e comentário).
  - A Story tem nota opcional do momento; cada `StoryWine` tem nota opcional do vinho.
  - Invariante: toda Story tem ao menos um `StoryWine`.
- **Alternativas consideradas:** (A) lista de Wines — não identifica a garrafa nem guarda impressão por vinho; (B) lista de garrafas — exigiria garrafas fictícias para restaurantes e presentes.
- **Consequências:** o protótipo `Story` (com `wineIds` e `rating`) será substituído. Ficam em aberto pessoas, lugares, fotos e pratos; o efeito da Story sobre a adega (Decisão 3); e a escala das notas.

## ADR-017 — Pessoas, lugares, fotos, pratos e notas

- **Status:** Aprovada em 19/10/2026.
- **Contexto:** o protótipo de `Story` guardava pessoas, local, fotos e pratos como textos soltos, o que impede a IA de reconhecer a mesma pessoa ou o mesmo lugar em histórias diferentes.
- **Decisão:**
  - Critério: o que precisa ser reconhecido em várias histórias tem identidade (entidade); o resto é detalhe da história (Value Object).
  - `Person` e `Place` são entidades com cadastro próprio e privado; a Story as referencia pelo id.
  - Fotos são Value Objects dentro da Story.
  - Pratos são Value Objects dentro do `StoryWine`, representando a harmonização com aquele vinho.
  - Notas de 1 a 5, inteiras, opcionais na Story e no `StoryWine`.
  - Dados de `Person` e `Place` são privados do usuário e usados apenas em respostas para ele.
- **Alternativas consideradas:** textos soltos na Story (protótipo) — sem identidade, não respondem perguntas de recorrência; pratos na Story — não indicam com qual vinho harmonizaram; escalas de 100 pontos ou com meio ponto — mais jargão e complexidade.
- **Consequências:** surgem cadastros privados de pessoas e lugares; o limite formal de agregado de `Person` e `Place` será confirmado na Decisão 3.

## ADR-019 — Limites de agregados, CellarLot e consumo

- **Status:** Aprovada em 12/11/2026.
- **Contexto:** faltava definir os agregados de cada contexto, como representar as garrafas da adega e o que acontece quando uma história usa uma garrafa da adega.
- **Decisão:**
  - Agregados: Catálogo (`Wine`, `Producer`, `Country`, `Region`, `Grape`); Histórias (`Story`, `Person`, `Place`); Adega (`CellarLot`); Perfil (`UserProfile`). Sommelier AI apenas lê os demais contextos.
  - Agregados se referenciam somente por id; `Region` e `GrapeComposition` passarão a guardar ids em vez de objetos.
  - Garrafas da adega são representadas por lotes (`CellarLot`): uma aquisição de N garrafas idênticas, com quantidade disponível que nunca fica negativa.
  - O `StoryWine` referencia o lote de onde a garrafa saiu.
  - Abrir uma garrafa para beber sempre gera uma Story (mesmo mínima). Baixas avulsas (quebra, estrago, doação) são registradas no lote, com motivo, sem Story.
  - No MVP, o caso de uso "Registrar história" coordena a criação da Story e a baixa no lote; eventos de domínio ficam para depois.
- **Alternativas consideradas:** (A) um registro por garrafa — preciso, porém trabalhoso; (C) compra com itens — mais complexo e não representa presentes; consumo sem Story — permitiria perder lembranças; eventos de domínio já no MVP — complexidade prematura.
- **Consequências:** o código de `Region` e `GrapeComposition` precisa ser ajustado; o protótipo `Wine` perde os campos de compra, que passam ao `CellarLot`; a localização física de garrafas na adega fica fora do MVP.

## ADR-020 — Padrões técnicos do domínio

- **Status:** Aprovada em 12/11/2026.
- **Contexto:** o código misturava `assert` (inativo em release) e `ArgumentError` para validação; `Money` usava `double`; `Vintage` usava `null` para dois significados diferentes.
- **Decisão:**
  - Validação por exceção de domínio própria (`DomainException implements Exception`) em todas as entidades e Value Objects.
  - `Money` em centavos (`int`) com código de moeda ISO 4217; sem conversão no MVP.
  - `Vintage` como `sealed class` com `VintageYear`, `NonVintage` e `UnknownVintage`; ano entre 1800 e o ano atual.
- **Alternativas consideradas:** `assert` — inativo em release; `ArgumentError` — sinaliza bug, não regra de negócio; tipo `Result` — mais conceitos neste momento do aprendizado; `double` para dinheiro — erros de arredondamento; `Vintage?` com `null` — ambíguo.
- **Consequências:** `Vintage`, `Quantity`, `AlcoholContent`, `PackageSize`, `Money`, `Country`, `Grape` e `GrapeComposition` serão ajustados na fase de código, com testes.

## ADR-021 — Tipo do vinho e composição de uvas

- **Status:** Aprovada em 13/11/2026.
- **Contexto:** a IA precisa distinguir tipos de vinho ("qual o melhor espumante que já tomei?"), e a composição de uvas precisava de regras de consistência.
- **Decisão:**
  - Tipo do vinho (`WineType`) opcional, em lista única: tinto, branco, rosé, laranja, espumante, fortificado e sobremesa.
  - A mesma uva não aparece duas vezes na composição de um Wine.
  - A soma dos percentuais conhecidos das uvas não passa de 100%.
- **Alternativas consideradas:** duas dimensões (cor e estilo) — mais precisa, porém exige mais uma escolha do usuário; sem tipo no MVP — impede perguntas por tipo.
- **Consequências:** um espumante rosé é registrado como "espumante". Se a precisão de cor e estilo for necessária no futuro, cada tipo da lista pode ser desdobrado.

## ADR-022 — Person e Place

- **Status:** Aprovada em 14/11/2026.
- **Contexto:** era preciso definir os dados e a identidade de pessoas e lugares do contexto Histórias, considerando privacidade de terceiros.
- **Decisão:**
  - `Person` guarda somente o nome (princípio da necessidade da LGPD).
  - Identidade de `Person` = nome normalizado (sem maiúsculas, acentos e espaços extras). Duas pessoas com a mesma grafia são a mesma pessoa; o usuário diferencia homônimos pela grafia.
  - `Place` tem tipo opcional (`PlaceType`: casa, restaurante, bar, vinícola, loja de vinhos, evento, outro) e cidade opcional em texto livre.
  - Identidade de `Place` é apenas o id: lugares com o mesmo nome podem ser diferentes.
  - `Country`, `Grape`, `Producer` e `Region` passam a estender `AggregateRoot`, conforme a ADR-019.
- **Alternativas consideradas:** Person identificada só pelo id — permitiria duplicatas silenciosas que distorcem "com quem mais compartilho vinho?"; mais dados de pessoas (contato, foto) — desnecessários e sensíveis; cadastro próprio de cidades — complexidade prematura.
- **Consequências:** o caso de uso de cadastro de pessoa deve impedir duplicatas pelo nome normalizado. A detecção de duplicatas de lugares, se desejada, será decidida depois.

## ADR-023 — Prioridade do produto no MVP

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** Contexto comum (ADR-023 a ADR-029): incorporação dos aprendizados da catalogação real de 12 garrafas (ver `docs/PRODUCT_EVOLUTION_PLAN.md`). O novo documento de produto prioriza inventário, valor da coleção e momento de consumo; a ADR-001 prioriza memórias.
- **Decisão:** o MVP contém as duas jornadas. **Histórias** é a identidade do produto; **Adega** é a porta de entrada (o usuário começa catalogando e cada garrafa aberta vira uma história). A ADR-001 permanece válida.
- **Alternativas consideradas:** só Histórias no MVP — não atende ao uso real de catalogação; só Adega — descaracteriza a proposta de valor.
- **Consequências:** o escopo do MVP inclui lotes, compras, custo, estimativa de valor e janela de consumo, além de Histórias.

## ADR-024 — Catálogo privado e sugestões de IA

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** o cadastro assistido sugere dados de referência; o documento pede separar catálogo global de dados privados.
- **Decisão:** mantém-se a ADR-015 no MVP. Dados sugeridos por IA ou fontes externas só passam a integrar o catálogo privado após confirmação do usuário. Catálogo global compartilhado é evolução futura.
- **Alternativas consideradas:** catálogo global já no MVP — deduplicação entre usuários, moderação e custo.
- **Consequências:** o modelo de procedência (ADR-027) sustenta a separação entre sugerido e confirmado.

## ADR-025 — Presente com história opcional

- **Status:** Aprovada em 18/11/2026. Revisa parcialmente a ADR-019.
- **Contexto:** a ADR-019 tratava garrafa doada como baixa avulsa sem Story.
- **Decisão:** abrir para beber continua exigindo uma Story. Presentear uma garrafa permite registrar uma Story opcional; sem Story, é uma baixa avulsa com motivo "presente". Quebra e estrago continuam como baixas avulsas.
- **Alternativas consideradas:** presente sempre com Story — atrito desnecessário; presente nunca com Story — perde memórias relevantes.
- **Consequências:** o caso de uso de baixa por presente aceita uma Story opcional.

## ADR-026 — Acquisition (compra)

- **Status:** Aprovada em 18/11/2026. Revisa parcialmente a ADR-019, que havia descartado "compra com itens".
- **Contexto:** compras reais incluem lotes promocionais de vinhos diferentes com valor total conhecido e sem preço individual (ex.: 4 vinhos por R$ 599,93).
- **Decisão:** `Acquisition` agrupa um ou mais `CellarLot` e registra valor total pago (opcional, com moeda), data (pode ser desconhecida), origem (compra ou presente recebido) e fornecedor (opcional). O preço unitário do lote é opcional. Não há rateio automático do valor total.
- **Alternativas consideradas:** ratear igualmente — inventa dado; exigir preço individual — impede registrar o caso real.
- **Consequências:** custo da coleção é apresentado por compra e por moeda; lotes sem preço individual aparecem como parte de compra conjunta.

## ADR-027 — Procedência dos dados

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** dados sugeridos por IA precisam ser distinguíveis dos confirmados, com origem e confiança.
- **Decisão:** um Value Object de procedência acompanha os campos enriquecíveis: origem (usuário, sugestão de IA, fonte externa), confiança (baixa, média, alta), fonte, data do registro e confirmação. Campos de identidade do Wine (produtor, nome, safra) só existem confirmados. Campos de enriquecimento (região, uvas, teor alcoólico, janela de consumo, classificação, harmonização, avaliações da crítica, estimativas de valor) podem ficar como sugestão.
- **Alternativas consideradas:** aceitar sugestões como fatos — viola a ADR-001 (não inventar); não guardar sugestões — perde o enriquecimento progressivo.
- **Consequências:** interface e IA sempre distinguem fato de sugestão. Detalhamento técnico na Sprint 1.

## ADR-028 — IA fora do MVP

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** serviços de IA são pagos; o documento exige funcionamento sem serviços externos de IA (ex.: relatório).
- **Decisão:** o MVP funciona com cadastro manual e enriquecimento progressivo. Cadastro assistido por IA entra na próxima versão, encaixando-se no modelo de procedência.
- **Alternativas consideradas:** IA no MVP — custo, dependência e risco de dados inventados antes de existir a camada de procedência.
- **Consequências:** nenhuma dependência de serviço pago no MVP.

## ADR-029 — Ordem de preferência de pesquisa

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** a ordem foi definida em conversas anteriores, mas não estava registrada no repositório.
- **Decisão:** a pesquisa de vinhos privilegia, nesta ordem: uva, região, produtor e rótulo. O país é apresentado associado à região.
- **Consequências:** orienta a futura funcionalidade de pesquisa (próxima versão).

## ADR-030 — Regras da Story e do StoryWine

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** detalhamento do Passo 6, considerando a história opcional de presente (ADR-025).
- **Decisão:**
  - Título (ou ocasião) da Story é opcional; a história mínima tem data e um vinho.
  - Cada `StoryWine` tem um destino: bebido (padrão) ou presenteado. Vinho presenteado não recebe nota do vinho, pois não foi provado; a nota do momento continua permitida.
  - A data da Story não pode estar no futuro (comparação por dia).
  - Trocar o vinho de um `StoryWine` (ex.: completar safra desconhecida) é recusado quando o item veio de um lote da adega; nesse caso a correção pertence ao lote.
  - `Place` mantém identidade apenas pelo id (confirmação da ADR-022).
- **Alternativas consideradas:** título obrigatório — atrito no registro rápido; permitir nota de vinho presenteado — a IA afirmaria uma avaliação inexistente; permitir troca de vinho em item da adega — quebraria a regra "Wine do StoryWine = Wine do lote" (ADR-019).
- **Consequências:** `StoryWine` é uma entidade interna com id próprio; `Rating`, `Photo` e `Dish` são Value Objects.

## ADR-031 — Limite entre Acquisition e CellarLot

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** a ADR-026 criou `Acquisition` e deixou pendente se ela contém os lotes ou os referencia.
- **Decisão:** `CellarLot` e `Acquisition` são Aggregate Roots independentes. O lote referencia a compra pelo id. O `StoryWine` continua referenciando o lote (ADR-019). A ligação entre compra e lotes é garantida pelo caso de uso "Registrar compra".
- **Alternativas consideradas:** Acquisition contendo os lotes — abrir uma garrafa alteraria a compra inteira, e o StoryWine precisaria referenciar uma entidade interna de outro agregado.
- **Regras complementares (aprovadas em 18/11/2026):** presente recebido (`AcquisitionOrigin.gift`) não tem valor pago; data da compra não pode estar no futuro.
- **Consequências:** abrir uma garrafa altera somente o lote. Regras que envolvem compra e lotes juntos (ex.: moedas compatíveis) ficam nos casos de uso.

## ADR-032 — Janela de consumo e valor de mercado

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** Sprint 1 (ADR-023, ADR-027): identificar o momento de consumo e acompanhar o valor estimado da coleção.
- **Decisão — status de consumo** (ano atual Y; janela de A a B; melhor fase opcional de P1 a P2):
  - sem janela → **Sem informação** (nunca há palpite);
  - Y < A → **Pode esperar**;
  - Y > B → **Atenção à guarda**;
  - Y = B (último ano) → **Abrir agora**;
  - com melhor fase e Y < P1 → **Pode esperar** (já pode abrir, mas tende a melhorar);
  - demais anos dentro da janela → **No melhor momento**;
  - janela não confirmada → categoria apresentada como sugestão.
- **Decisão — MarketValuation:** estimativa com valor e moeda, tipo (reposição ou revenda), data de referência (pode ser desconhecida) e procedência. Ligada ao Wine pelo id. Histórico: nova estimativa não apaga a anterior; a vigente é a registrada mais recentemente para o vinho e o tipo.
- **Alternativas consideradas:** categorias calculadas por IA — pouco explicáveis no MVP; valor de mercado como campo único do Wine — perderia histórico e procedência.
- **Consequências:** regras testáveis e explicáveis ao usuário; o valor estimado da coleção multiplica a estimativa vigente pelas garrafas disponíveis.

## ADR-033 — Embalagem, código de lote e adiamento da procedência no Wine

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** o cadastro deve suportar diferentes embalagens, e há garrafas com código de lote do fabricante (ex.: "L2624426").
- **Decisão:**
  - `PackageType` no `CellarLot`: garrafa (padrão), lata, bag-in-box e outro.
  - Código de lote do fabricante como texto opcional no `CellarLot`. Nunca é usado para inferir safra.
  - Aplicar `Sourced` aos campos enriquecíveis do `Wine` (região, uvas, teor alcoólico) fica para a Sprint 2, junto com o caso de uso de cadastro, para não alterar o `Wine` duas vezes.
- **Alternativas consideradas:** tipo de embalagem no `Wine` — a embalagem pertence à unidade física, não ao catálogo (ADR-014).
- **Consequências:** o vinho 012 da adega real registra o código "L2624426" com safra desconhecida.

## ADR-034 — Organização em camadas e repositórios

- **Status:** Aprovada em 18/11/2026.
- **Contexto:** início da camada de aplicação (Sprint 2); a ADR-008 deixou a estrutura de pastas para a fase de código.
- **Decisão:**
  - Organização por camada: `lib/core/domain/` (regras e contratos de repositório), `lib/core/application/` (casos de uso) e `lib/infrastructure/` (implementações: memória e, depois, persistência).
  - Repositórios são contratos (`interface class`) assíncronos no domínio; casos de uso dependem apenas dos contratos.
  - Casos de uso validam todas as regras antes de salvar qualquer dado ("tudo ou nada").
  - Primeiro caso de uso: "Registrar história".
- **Alternativas consideradas:** pastas por contexto (`catalog/`, `cellar/`, `stories/`) — melhor para projetos grandes, mas exigiria mover todo o código existente agora.
- **Consequências:** a persistência da Sprint 3 deve oferecer transação para que salvar lotes e história seja atômico. Reavaliar a organização por contexto quando o app crescer.

## Regra de manutenção
Registrar novas decisões com status, contexto, alternativas, consequências e data. Não transformar propostas em decisões aprovadas sem confirmação do responsável.
