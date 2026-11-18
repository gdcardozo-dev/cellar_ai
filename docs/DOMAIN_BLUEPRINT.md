# Cellar AI — Domain Blueprint (RASCUNHO PARA VALIDAÇÃO)

## 1. Visão do produto — APROVADA
Produto orientado a experiências e memórias com vinho. O valor central está em preservar, conectar e redescobrir momentos, pessoas, lugares e vinhos. O controle da adega é uma capacidade complementar, não a identidade principal.

## 2. Linguagem ubíqua — PROPOSTA
- **Story:** registro de uma experiência significativa relacionada a vinho. Contém ao menos um StoryWine (APROVADO — ver seção 7).
- **StoryWine ("vinho da história"):** a participação de um Wine em uma Story, com a impressão do usuário sobre aquele vinho naquele momento (APROVADO — ver seção 7).
- **Person:** pessoa com quem o usuário compartilhou uma experiência; cadastro privado (APROVADO — ver seção 7.2).
- **Place:** local de uma experiência (restaurante, casa, vinícola, cidade); cadastro privado (APROVADO — ver seção 7.2).
- **Wine:** descrição de um vinho no catálogo, independente de posse. Identificado por Produtor + Nome comercial + Safra (APROVADO — ver seção 5.1).
- **CellarLot ("lote da adega"):** uma aquisição de N garrafas idênticas do mesmo Wine e tamanho (compra ou presente), com quantidade disponível (APROVADO — ver seção 4.2).
- **Producer:** produtor do vinho.
- **Grape:** variedade de uva.
- **Region:** região geográfica, potencialmente hierárquica.
- **Vintage:** safra, com três estados: ano, sem safra declarada (NV) ou desconhecida (APROVADO — ver seção 5.1).
- **Package:** tipo de embalagem e volume; modelagem final pendente. Não faz parte da identidade de Wine (APROVADO).
- **GrapeComposition:** composição de uma ou mais uvas com percentuais opcionais.

## 3. Bounded contexts — APROVADOS (ADR-008, ADR-019)
- **Catálogo (Wine Catalog):** informações de referência sobre vinhos, produtores, países, regiões e uvas.
- **Adega (Personal Cellar):** aquisições, posse, disponibilidade e baixas.
- **Histórias (Stories):** experiências, lembranças, pessoas e lugares.
- **Sommelier AI:** interpretação, recomendações e recuperação contextual. **Somente lê** os demais contextos; não possui agregados.
- **Perfil (User Profile):** preferências e configurações pessoais.
Os contextos são conceituais; a estrutura de pastas correspondente será definida na fase de código.

## 4. Aggregates — APROVADOS (ADR-019)

### 4.1 Regras gerais
- De fora, só se altera um agregado por meio do seu Aggregate Root.
- Um agregado referencia outro **somente pelo id**, nunca guardando o objeto inteiro.

| Contexto | Aggregate Root | Contém | Referencia (por id) |
|---|---|---|---|
| Catálogo | `Wine` | `GrapeComposition`, características | `Producer`, `Region`, `Grape` |
| Catálogo | `Producer`, `Country`, `Grape` | — | — |
| Catálogo | `Region` | — | `Country` (e região-mãe, se houver) |
| Histórias | `Story` | `StoryWine` (com pratos), fotos | `Wine`, `CellarLot`, `Person`, `Place` |
| Histórias | `Person`, `Place` | — | — |
| Adega | `CellarLot` | baixas avulsas | `Wine` |
| Perfil | `UserProfile` | preferências | — |

**Consequência no código atual:** `Region` deixa de guardar o objeto `Country`, e `GrapeComposition` deixa de guardar o objeto `Grape`; ambos passam a guardar apenas o id.

### 4.2 CellarLot ("lote da adega") — APROVADO (ADR-019, ADR-026)
- Um lote representa garrafas idênticas (mesmo Wine e `PackageSize`) de **uma compra** (`Acquisition`): quantidade adquirida, quantidade disponível e preço unitário (opcional).
- 12 garrafas do mesmo vinho adquiridas juntas = 1 lote com quantidade 12.
- **Invariante:** a quantidade disponível nunca fica negativa.
- **Baixas avulsas** (garrafa quebrada, vinho estragado, garrafa presenteada sem história) são registradas no próprio lote, com motivo, e não geram Story.
- **PROPOSTA (Sprint 1):** código de lote do fabricante (ex.: "L2624426") como texto opcional. Nunca é usado para inferir safra.

### 4.4 Acquisition ("compra") — APROVADO (ADR-026)
- Agrupa um ou mais `CellarLot`: valor total pago (opcional, `Money` com moeda), data (pode ser desconhecida), origem (compra ou presente recebido) e fornecedor (opcional).
- Exemplo: lote promocional com 4 vinhos diferentes por R$ 599,93 = 1 Acquisition → 4 CellarLots sem preço individual.
- **Sem rateio automático:** o valor total nunca é dividido entre os lotes pelo sistema.
- **Limite de agregado (ADR-031):** Acquisition e CellarLot são Aggregate Roots separados; o lote referencia a compra pelo id.
- **Regras complementares (ADR-031, aprovadas em 18/11/2026):** presente recebido não tem valor pago; data da compra não pode estar no futuro.
- **Retiradas do lote:** retirada para história (1 garrafa) e baixa avulsa (`CellarRemoval`: motivo, quantidade, data, observação). Motivos: quebrada, estragada, presenteada sem história, outro.

### 4.3 Consumo e coordenação entre agregados — APROVADO (ADR-019)
- **Abrir uma garrafa para beber sempre gera uma Story**, mesmo mínima (data e vinho). Coerente com o lema "Cada garrafa conta uma história".
- O caso de uso **"Registrar história"** cria a Story e, para cada StoryWine que veio da adega, baixa 1 unidade do `CellarLot` correspondente.
- O caso de uso também garante que o Wine do StoryWine seja o mesmo Wine do lote referenciado.
- Eventos de domínio (ex.: `BottleConsumed`) ficam para quando houver necessidade real; no MVP a coordenação é feita pelo caso de uso.
- **Presente (ADR-025):** presentear uma garrafa permite registrar uma Story opcional; sem Story, é baixa avulsa com motivo "presente".

## 5. Entidades e Value Objects — DEFINIDOS
Fundação revisada: `EntityId`, `Entity`, `AggregateRoot`.
Entidades de catálogo discutidas: `Wine`, `Producer`, `Country`, `Region`, `Grape`.
Value Objects discutidos: `PackageSize`, `Vintage`, `AlcoholContent`, `Money`, `Quantity`, `GrapeComposition`.
`Wine` e `Story` atuais são protótipos; não promover campos atuais a contrato final.

## 5.0 Padrões técnicos do domínio — APROVADOS (ADR-020)
- **Validação:** entidades e Value Objects recusam dados inválidos lançando uma exceção de domínio própria (`DomainException`, que implementa `Exception`). Não se usa `assert` para regras de negócio (é desligado em builds de release) nem `ArgumentError` (que, por convenção do Dart, indica erro de programação). A camada de apresentação captura a exceção e mostra uma mensagem amigável.
- **Money:** valor em **centavos (`int`)** + **código da moeda** (ISO 4217: `BRL`, `USD`, `ARS`...). Sem conversão entre moedas no MVP.
- **Vintage:** `sealed class` com exatamente três casos — `VintageYear(ano)`, `NonVintage` e `UnknownVintage`. O compilador obriga todo código a tratar os três casos. Ano aceito entre 1800 e o ano atual.

## 5.0.1 Procedência dos dados — APROVADO (ADR-027)
- Campos enriquecíveis carregam procedência: origem (usuário, sugestão de IA, fonte externa), confiança (baixa, média, alta), fonte, data do registro e confirmação.
- **Identidade do Wine (produtor, nome, safra) só existe confirmada.** Sugestões de IA para esses campos ficam no fluxo de cadastro, nunca no Wine.
- Podem ficar como sugestão: região, uvas, teor alcoólico, janela de consumo, classificação, harmonização, avaliações da crítica e estimativas de valor.
- Sugestões só passam ao catálogo privado após confirmação do usuário (ADR-024).

## 5.0.2 Valor de mercado e janela de consumo — PROPOSTA (Sprint 1)
- **MarketValuation:** valor e moeda, tipo (reposição ou revenda), data de referência (pode ser desconhecida), data do registro, fonte e confiança. Histórico: uma estimativa nova não apaga a anterior. Ligada ao Wine. Não se confunde com custo pago (Acquisition/CellarLot).
- **DrinkingWindow:** ano inicial, pico (opcional) e ano limite, com procedência.
- **Status de consumo**, calculado por regras explícitas: Pode esperar · Abrir agora · No melhor momento · Atenção à guarda · Sem informação. Os limiares exatos dependem de aprovação.

## 5.1 Identidade de Wine — APROVADA (ADR-014, ADR-015)
- **Identidade:** dois registros representam o mesmo Wine quando têm o mesmo **Produtor + Nome comercial + Safra**.
- **Safra faz parte da identidade:** Catena Alta Malbec 2021 e 2022 são Wines diferentes.
- **Três estados de safra:**
  - **Ano** (ex.: 2022): fato sobre o vinho.
  - **NV — sem safra declarada** (ex.: muitos espumantes): fato sobre o vinho.
  - **Desconhecida:** o vinho tem safra, mas o usuário não a registrou. É falta de informação, não fato; pode ser completada depois. A IA nunca deve presumir um ano.
- **Características, não identidade:** país, região, uvas, teor alcoólico e estilo. Corrigi-las não transforma o vinho em outro.
- **Tamanho da embalagem fora do Wine:** `PackageSize` pertence à unidade física (garrafa), não ao catálogo.
- **Agrupamento por rótulo:** "todas as safras de um vinho" é calculado a partir de Produtor + Nome comercial. Não há classe `WineLabel` (ADR-010 continua adiada).
- **Tipo do vinho (ADR-021):** campo opcional, lista única em linguagem simples: tinto, branco, rosé, laranja, espumante, fortificado e sobremesa. Um espumante rosé é "espumante".
- **Uvas (ADR-021):** a mesma uva não aparece duas vezes na composição; a soma dos percentuais conhecidos não passa de 100%.
- **Duplicatas:** o Wine sabe comparar sua identidade com a de outro; impedir cadastro duplicado é responsabilidade do caso de uso de cadastro, que consulta o catálogo.
- **Catálogo privado no MVP:** cada usuário mantém seu próprio catálogo. O modelo não deve impedir um catálogo compartilhado no futuro.

### Regras complementares — APROVADAS (ADR-014)
- **Comparação de nomes:** para fins de identidade, a comparação ignora maiúsculas/minúsculas, acentos e espaços extras ("Château Margaux" = "chateau  margaux"). O nome é exibido como o usuário digitou.
- **Completar safra desconhecida:** atualiza-se o **registro da experiência**, não o Wine compartilhado. A experiência passa a referenciar o Wine com o ano correto (criado se ainda não existir). O Wine com safra desconhecida permanece para as demais experiências que o referenciam. Motivo: atualizar o Wine compartilhado alteraria outras lembranças por tabela, violando o princípio de não inventar lembranças.
- **Produtor desconhecido:** representado por um produtor "Produtor Desconhecido". Para evitar que vinhos distintos se confundam (ex.: vinhos da casa de restaurantes diferentes), o nome comercial deve ser descritivo, como "Tinto da casa — Fasano"; a interface pode sugerir o nome do local.

## 6. Decisões de modelagem discutidas
- Separar nome comercial do vinho de Producer.
- Vintage com três estados (ano, NV, desconhecida) — substitui "Vintage opcional" (ADR-014).
- Separar dados de catálogo de dados de compra/estoque.
- Preferir uvas estruturadas a lista de strings; blends podem ter múltiplas uvas e percentuais desconhecidos.
- Região pode ter hierarquia por `parentRegion` (proposta).
- PackageSize expressa volume, não tipo de embalagem.
- WineVariant e WineLabel foram explorados, mas adiados.

## 7. Relacionamentos — PARCIALMENTE APROVADOS

### 7.1 Story → vinhos — APROVADO (ADR-016)
A Story referencia vinhos por meio de uma lista de **StoryWine**. Cada StoryWine contém:
- **Wine** (obrigatório): referência ao vinho do catálogo.
- **Lote da adega** (opcional): referência ao `CellarLot` de onde a garrafa saiu; preenchida somente quando o vinho veio da adega pessoal do usuário.
- **Impressão do usuário** (opcional): nota e comentário sobre aquele vinho naquele momento.

Cenários atendidos:
- **Em casa:** Wine + lote da adega.
- **Restaurante ou presente aberto na hora:** somente Wine; não se presume que o vinho veio da adega.
- **Degustação:** vários StoryWine, cada um com sua impressão.

**Avaliações:** a Story tem nota opcional **do momento**; cada StoryWine tem nota opcional **do vinho**. São independentes: um vinho mediano pode estar em uma noite inesquecível.

**Invariantes da Story:**
1. Uma Story tem **pelo menos um StoryWine**. Vinhos não identificados usam as regras da seção 5.1 (produtor e/ou safra desconhecidos).

**Completar safra desconhecida:** troca-se o Wine referenciado pelo StoryWine daquela Story (seção 5.1).

**Regras complementares — APROVADAS (ADR-030):**
- Título/ocasião opcional; história mínima = data + um vinho.
- Destino de cada StoryWine: bebido (padrão) ou presenteado. Vinho presenteado não recebe nota do vinho.
- Data da Story não pode estar no futuro.
- Trocar o Wine de um StoryWine vindo de lote da adega é recusado; a correção pertence ao lote.

### 7.2 Pessoas, lugares, fotos, pratos e notas — APROVADO (ADR-017)
Critério: se a IA precisa reconhecer a mesma coisa em várias histórias, ela tem identidade (entidade); se não, é detalhe da história (Value Object).

| Conceito | Tipo | Onde vive | Pergunta que atende |
|---|---|---|---|
| **Person** | Entidade, com cadastro próprio e privado do usuário | Story referencia pelo id | "Com quem mais compartilho vinho?" |
| **Place** | Entidade, com cadastro próprio e privado do usuário | Story referencia pelo id | "Qual restaurante mais aparece nas minhas histórias?" |
| **Foto** | Value Object | Dentro da Story | — |
| **Prato** | Value Object | Dentro do **StoryWine** (harmonização daquele vinho) | "Qual foi a melhor harmonização que já fiz?" |

- **Notas:** escala de **1 a 5, inteiros**, exibidas como estrelas; opcionais tanto na Story (momento) quanto no StoryWine (vinho).
- **Person (ADR-022):** guarda somente o nome (princípio da necessidade). Identidade de domínio = nome normalizado: duas pessoas com a mesma grafia são a mesma pessoa; homônimos são diferenciados pela grafia ("Ana Bolena", "Ana de Brasília").
- **Place (ADR-022):** nome, tipo opcional (casa, restaurante, bar, vinícola, loja de vinhos, evento, outro) e cidade opcional em texto livre. Identidade apenas pelo id: dois "Bar do Zé" em cidades diferentes são lugares diferentes. Confirmado em 18/11/2026 (ADR-030).
- **Privacidade:** dados de Person e Place (inclusive de terceiros) são privados do usuário e usados apenas em respostas para ele próprio.
- `Person` e `Place` são Aggregate Roots próprios no contexto Histórias (ADR-019).

### 7.3 Story e adega — APROVADO (ADR-019)
Ver seção 4.3: o caso de uso "Registrar história" baixa 1 unidade do lote para cada StoryWine vindo da adega.

## 8. Eventos de domínio — EXEMPLOS, NÃO IMPLEMENTADOS
`StoryCreated`, `StoryRated`, `BottleAdded`, `BottleConsumed`, `WineReviewed`.

## 9. Roadmap
Antes de implementar `Wine`/`Story`: fechar conceitos, limites e invariantes. Depois definir testes de domínio, interfaces e casos de uso, mantendo alterações incrementais.

## 10. IA e privacidade — DIREÇÃO
A IA interpreta dados de catálogo e registros pessoais para responder perguntas sobre experiências e preferências. Diferenciar fatos fornecidos pelo usuário de inferências. Não inventar lembranças. Definir autorização, consentimento e retenção antes de explorar dados sensíveis de pessoas e locais.

## 11. Princípios arquiteturais
Domínio independente de frameworks e infraestrutura. Evitar complexidade prematura. Preferir tipos de domínio onde agregam validação/semântica. Um Aggregate Root protege invariantes e fronteiras de consistência. Documentar hipóteses e obter validação antes de codificar.
