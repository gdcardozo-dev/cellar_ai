# Cellar AI — transferência de projeto

## Objetivo
Continuar o desenvolvimento Flutter/Dart no Claude Code (VS Code) sem perder decisões, contexto e método de trabalho.

## Visão e experiência
**Decisão aprovada:** produto orientado a experiências e memórias envolvendo vinho, não apenas inventário. Formulação preferida pelo responsável: “Um assistente que preserva e conecta minhas melhores experiências com vinho.”

**Slogan aprovado:** “Cada garrafa conta uma história.”
**Abertura aprovada:** “Hoje é um ótimo dia para abrir um grande vinho.”
**Jornada escolhida:** “Histórias”.
**Direção de UX:** linguagem simples e clara, menos terminologia enológica, experiência intuitiva; light mode inicialmente, dark mode posteriormente.
**Ideia de produto:** interpretar cartas de vinho de restaurantes para sugerir harmonizações entre entrada, principal e sobremesa (futuro; não assumir implementado).

## Ambiente e repositório
- Repositório informado: https://github.com/gdcardozo-dev/cellar_ai
- Diretório local: `C:\Projetos\cellar_ai`
- Branches: `main` e `develop`; trabalho habitual em `develop`.
- Flutter 3.44.6 / Dart 3.12.2 foram informados anteriormente; conferir versões instaladas atualmente.
- Windows, VS Code, Git e Chrome para execução.
- Firebase criado/planejado como backend; verificar integrações reais no código.

## Estrutura relatada
`lib/app`, `lib/core/domain`, `lib/design`, `lib/features`, `lib/shared`.
Domínio inclui `foundation/{entity,aggregate_root}.dart`, `value_objects/{entity_id,package_size,vintage,alcohol_content,money,quantity,grape_composition}.dart`, `entities/{country,region,grape,producer,wine,story}.dart`.
Teste conhecido: `test/core/domain/value_objects/package_size_test.dart`.
Documentos conhecidos: `docs/VISION.md`, `BACKLOG.md`, `DOMAIN_MAP.md`, `DOMAIN_MODEL.md`, `QUESTIONS_THE_AI_MUST_ANSWER.md`, `WINE_DOMAIN_MODEL.md`.
Verificar todos os caminhos contra o repositório atual.

## Sprint 0 — situação ao transferir
Concluídos: revisão de `pubspec.yaml`, `analysis_options.yaml`, execução do analyzer, revisão de `EntityId`, formatação, revisão de `Entity` e `AggregateRoot`, análise preliminar de `Wine` e `Story`.
`entity_id.freezed.dart` órfão removido; analyzer passou de 33 issues para quatro warnings de imports não usados.
`dart format .`: 26 arquivos formatados. Último analyzer informado: 0 erros e 4 warnings.
Testes de `PackageSize`: 6 passaram anteriormente, antes das últimas alterações; rodar novamente.

## Próxima etapa
Produzir e validar o **Domain Blueprint** antes de implementar/refatorar `Wine` e `Story`.
O arquivo entregue é um rascunho inicial, não a especificação definitivamente aprovada.

## Perguntas ainda abertas
- Limites de agregados e bounded contexts definitivos.
- Identidade de Wine entre rótulos, safras e embalagens.
- Modelo de estoque: Bottle, OwnedBottle, lote de aquisição e quantidade.
- Story referencia Wine, uma unidade física, uma degustação, ou uma combinação?
- Fotos, pessoas, alimentos e locais: Value Objects, entidades ou referências externas?
- Invariantes e eventos de domínio; requisitos de privacidade e consentimento.

## Primeira instrução recomendada ao Claude
“Leia CLAUDE.md e os três documentos de transferência. Inspecione o código real, `git status`, `flutter analyze` e `flutter test`, mas não altere arquivos ainda. Apresente divergências, decisões aprovadas e questões em aberto. Depois proponha apenas a primeira decisão do Domain Blueprint para minha validação.”
