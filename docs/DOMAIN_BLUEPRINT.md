# Cellar AI — Domain Blueprint (RASCUNHO PARA VALIDAÇÃO)

## 1. Visão do produto — APROVADA
Produto orientado a experiências e memórias com vinho. O valor central está em preservar, conectar e redescobrir momentos, pessoas, lugares e vinhos. O controle da adega é uma capacidade complementar, não a identidade principal.

## 2. Linguagem ubíqua — PROPOSTA
- **Story:** registro de uma experiência significativa relacionada a vinho.
- **Wine:** descrição de um vinho no catálogo, independente de posse.
- **Bottle / OwnedBottle:** representação de posse de vinho; granularidade ainda em discussão.
- **Producer:** produtor do vinho.
- **Grape:** variedade de uva.
- **Region:** região geográfica, potencialmente hierárquica.
- **Vintage:** safra, opcional para vinhos sem safra declarada.
- **Package:** tipo de embalagem e volume; modelagem final pendente.
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
`Wine`, `Collection`, `Purchase` e `OwnedBottle` exigem avaliação específica.

## 5. Entidades e Value Objects — PARCIALMENTE DEFINIDOS
Fundação revisada: `EntityId`, `Entity`, `AggregateRoot`.
Entidades de catálogo discutidas: `Wine`, `Producer`, `Country`, `Region`, `Grape`.
Value Objects discutidos: `PackageSize`, `Vintage`, `AlcoholContent`, `Money`, `Quantity`, `GrapeComposition`.
`Wine` e `Story` atuais são protótipos; não promover campos atuais a contrato final.

## 6. Decisões de modelagem discutidas
- Separar nome comercial do vinho de Producer.
- Vintage opcional para NV e categorias semelhantes.
- Separar dados de catálogo de dados de compra/estoque.
- Preferir uvas estruturadas a lista de strings; blends podem ter múltiplas uvas e percentuais desconhecidos.
- Região pode ter hierarquia por `parentRegion` (proposta).
- PackageSize expressa volume, não tipo de embalagem.
- WineVariant e WineLabel foram explorados, mas adiados.

## 7. Relacionamentos — EM ABERTO
Story pode associar múltiplos vinhos e informações de contexto. Não presumir que cada vinho consumido veio da adega pessoal. Considerar experiências em restaurantes, presentes, degustações e compras não cadastradas.

## 8. Eventos de domínio — EXEMPLOS, NÃO IMPLEMENTADOS
`StoryCreated`, `StoryRated`, `BottleAdded`, `BottleConsumed`, `WineReviewed`.

## 9. Roadmap
Antes de implementar `Wine`/`Story`: fechar conceitos, limites e invariantes. Depois definir testes de domínio, interfaces e casos de uso, mantendo alterações incrementais.

## 10. IA e privacidade — DIREÇÃO
A IA interpreta dados de catálogo e registros pessoais para responder perguntas sobre experiências e preferências. Diferenciar fatos fornecidos pelo usuário de inferências. Não inventar lembranças. Definir autorização, consentimento e retenção antes de explorar dados sensíveis de pessoas e locais.

## 11. Princípios arquiteturais
Domínio independente de frameworks e infraestrutura. Evitar complexidade prematura. Preferir tipos de domínio onde agregam validação/semântica. Um Aggregate Root protege invariantes e fronteiras de consistência. Documentar hipóteses e obter validação antes de codificar.
