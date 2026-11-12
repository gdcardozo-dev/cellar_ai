# Cellar AI — Backlog

## Sprint 0 — Fundação e Domain Blueprint

### Concluído
- [x] Revisão de `pubspec.yaml`, `analysis_options.yaml` e análise estática
- [x] Revisão de `EntityId`, `Entity` e `AggregateRoot`
- [x] Remoção do arquivo órfão `entity_id.freezed.dart` e formatação do código
- [x] Documentos de transferência adicionados ao repositório
- [x] Passo 0 — organização da documentação (ADR-013)

### Próximas decisões do Domain Blueprint
- [x] Decisão 1 — Identidade de `Wine` (ADR-014) e catálogo privado no MVP (ADR-015)
- [x] Decisão 2 — A que uma `Story` se refere: `StoryWine` (ADR-016)
- [x] Decisão 2.1 — Pessoas, lugares, fotos, pratos e escala das notas (ADR-017)
- [x] Decisão 3 — Limites de agregados, bounded contexts e CellarLot (ADR-019)
- [x] Decisão 4 — DomainException, Money em centavos e Vintage como sealed class (ADR-020)

### Infraestrutura
- [x] Integração contínua no GitHub Actions (`dart format`, `flutter analyze`, `flutter test`)
- [ ] Ambiente local na máquina nova (VS Code, Git, Flutter SDK) — quando for implementar código

### Implementação do domínio (ADR-014 a ADR-020)
- [x] Passo 1 — `DomainException` e `Vintage` como sealed class, com testes
- [ ] Demais Value Objects: `Money` (centavos + moeda), `Quantity`, `AlcoholContent`, `PackageSize` com `DomainException`
- [ ] `Region` e `GrapeComposition` passam a guardar apenas ids
- [ ] Novo `Wine` (identidade Produtor + Nome + Safra)
- [ ] `Story`, `StoryWine`, `Person`, `Place`
- [ ] `CellarLot`

## Pendências técnicas identificadas (aguardando decisão)
- Flutter 3.47+ marca `package:flutter/material.dart` como obsoleto em favor do pacote `material_ui`; avaliar migração junto com a atualização da versão do Flutter (CI fixada em 3.44.6)
- `Quantity`, `AlcoholContent` e `PackageSize` ainda validam com `assert`, que não roda em builds de release
- `Money` usa `double` para valores monetários
- Dependências Freezed/JSON no `pubspec.yaml` sem uso no código
- `lib/app/theme.dart` e `lib/design/typography.dart` não são utilizados
- Comentário em `aggregate_root.dart` apresenta propostas (ADR-007) como fatos
- Botão da Home "Adicionar primeiro vinho" não reflete a jornada "Histórias"
- Branch `main` não recebe o trabalho da `develop` desde o início do domínio
