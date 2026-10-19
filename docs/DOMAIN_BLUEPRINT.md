# Cellar AI — Domain Blueprint (RASCUNHO PARA VALIDAÇÃO)

## 1. Visão do produto — APROVADA
Produto orientado a experiências e memórias com vinho. O valor central está em preservar, conectar e redescobrir momentos, pessoas, lugares e vinhos. O controle da adega é uma capacidade complementar, não a identidade principal.

## 2. Linguagem ubíqua — PROPOSTA
- **Story:** registro de uma experiência significativa relacionada a vinho. Contém ao menos um StoryWine (APROVADO — ver seção 7).
- **StoryWine ("vinho da história"):** a participação de um Wine em uma Story, com a impressão do usuário sobre aquele vinho naquele momento (APROVADO — ver seção 7).
- **Person:** pessoa com quem o usuário compartilhou uma experiência; cadastro privado (APROVADO — ver seção 7.2).
- **Place:** local de uma experiência (restaurante, casa, vinícola, cidade); cadastro privado (APROVADO — ver seção 7.2).
- **Wine:** descrição de um vinho no catálogo, independente de posse. Identificado por Produtor + Nome comercial + Safra (APROVADO — ver seção 5.1).
- **Bottle / OwnedBottle:** representação de posse de vinho; granularidade ainda em discussão.
- **Producer:** produtor do vinho.
- **Grape:** variedade de uva.
- **Region:** região geográfica, potencialmente hierárquica.
- **Vintage:** safra, com três estados: ano, sem safra declarada (NV) ou desconhecida (APROVADO — ver seção 5.1).
- **Package:** tipo de embalagem e volume; modelagem final pendente. Não faz parte da identidade de Wine (APROVADO).
- **GrapeComposition:** composição de uma ou mais uvas com percentuais opcionais.

## 3. Bounded contexts — HIPÓTESE
- Wine Catalog: informações de referência sobre vinhos, produtores, uvas e regiões.
- Personal Cellar: aquisições, posse, disponibilidade e movimentações.
- Stories: experiências e lembranças.
- Sommelier AI: interpretação, recomendações e recuperação contextual.
- User Profile: preferências e configurações pessoais.
Esses limites são sugestões, não uma estrutura de pastas já aprovada.

## 4. Aggregates — PENDENTE
`Story` é candidata natural a Aggregate Root de experiências. Isso **não** obriga toda informação relacionada a pessoas, fotos ou vinhos a pertencer ao agregado. Definir invariantes e ciclo de vida antes de decidir.
**APROVADO (ADR-016):** `StoryWine` pertence ao agregado `Story` e só é criado ou alterado por meio dela. Os demais limites (pessoas, lugares, fotos, pratos, garrafas) seguem pendentes.
`Wine`, `Collection`, `Purchase` e `OwnedBottle` exigem avaliação específica.

## 5. Entidades e Value Objects — PARCIALMENTE DEFINIDOS
Fundação revisada: `EntityId`, `Entity`, `AggregateRoot`.
Entidades de catálogo discutidas: `Wine`, `Producer`, `Country`, `Region`, `Grape`.
Value Objects discutidos: `PackageSize`, `Vintage`, `AlcoholContent`, `Money`, `Quantity`, `GrapeComposition`.
`Wine` e `Story` atuais são protótipos; não promover campos atuais a contrato final.

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
- **Garrafa da adega** (opcional): preenchida somente quando o vinho veio da adega pessoal do usuário.
- **Impressão do usuário** (opcional): nota e comentário sobre aquele vinho naquele momento.

Cenários atendidos:
- **Em casa:** Wine + garrafa da adega.
- **Restaurante ou presente aberto na hora:** somente Wine; não se presume que o vinho veio da adega.
- **Degustação:** vários StoryWine, cada um com sua impressão.

**Avaliações:** a Story tem nota opcional **do momento**; cada StoryWine tem nota opcional **do vinho**. São independentes: um vinho mediano pode estar em uma noite inesquecível.

**Invariantes da Story:**
1. Uma Story tem **pelo menos um StoryWine**. Vinhos não identificados usam as regras da seção 5.1 (produtor e/ou safra desconhecidos).

**Completar safra desconhecida:** troca-se o Wine referenciado pelo StoryWine daquela Story (seção 5.1).

### 7.2 Pessoas, lugares, fotos, pratos e notas — APROVADO (ADR-017)
Critério: se a IA precisa reconhecer a mesma coisa em várias histórias, ela tem identidade (entidade); se não, é detalhe da história (Value Object).

| Conceito | Tipo | Onde vive | Pergunta que atende |
|---|---|---|---|
| **Person** | Entidade, com cadastro próprio e privado do usuário | Story referencia pelo id | "Com quem mais compartilho vinho?" |
| **Place** | Entidade, com cadastro próprio e privado do usuário | Story referencia pelo id | "Qual restaurante mais aparece nas minhas histórias?" |
| **Foto** | Value Object | Dentro da Story | — |
| **Prato** | Value Object | Dentro do **StoryWine** (harmonização daquele vinho) | "Qual foi a melhor harmonização que já fiz?" |

- **Notas:** escala de **1 a 5, inteiros**, exibidas como estrelas; opcionais tanto na Story (momento) quanto no StoryWine (vinho).
- **Privacidade:** dados de Person e Place (inclusive de terceiros) são privados do usuário e usados apenas em respostas para ele próprio.
- Os limites formais de agregado de Person e Place serão confirmados na Decisão 3.

### 7.3 Demais relacionamentos — EM ABERTO
- Efeito de uma Story sobre a adega (abrir uma garrafa reduz a disponibilidade): depende dos limites de agregados (Decisão 3).

## 8. Eventos de domínio — EXEMPLOS, NÃO IMPLEMENTADOS
`StoryCreated`, `StoryRated`, `BottleAdded`, `BottleConsumed`, `WineReviewed`.

## 9. Roadmap
Antes de implementar `Wine`/`Story`: fechar conceitos, limites e invariantes. Depois definir testes de domínio, interfaces e casos de uso, mantendo alterações incrementais.

## 10. IA e privacidade — DIREÇÃO
A IA interpreta dados de catálogo e registros pessoais para responder perguntas sobre experiências e preferências. Diferenciar fatos fornecidos pelo usuário de inferências. Não inventar lembranças. Definir autorização, consentimento e retenção antes de explorar dados sensíveis de pessoas e locais.

## 11. Princípios arquiteturais
Domínio independente de frameworks e infraestrutura. Evitar complexidade prematura. Preferir tipos de domínio onde agregam validação/semântica. Um Aggregate Root protege invariantes e fronteiras de consistência. Documentar hipóteses e obter validação antes de codificar.
