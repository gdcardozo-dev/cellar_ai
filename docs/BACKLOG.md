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
- [ ] Decisão 2.1 — Pessoas, lugares, fotos e pratos na Story; escala das notas
- [ ] Decisão 3 — Limites de agregados e bounded contexts
- [ ] Decisão 4 — Padrão de validação dos Value Objects (`assert` × exceção) e `Money` em centavos

### Infraestrutura
- [ ] Integração contínua no GitHub Actions (`flutter analyze` + `flutter test`)
- [ ] Ambiente local na máquina nova (VS Code, Git, Flutter SDK) — quando for implementar código

## Pendências técnicas identificadas (aguardando decisão)
- 4 imports não utilizados em `country.dart`, `grape.dart`, `producer.dart` e `region.dart`
- Value Objects validados com `assert`, que não roda em builds de release
- `Money` usa `double` para valores monetários
- Dependências Freezed/JSON no `pubspec.yaml` sem uso no código
- `lib/app/theme.dart` e `lib/design/typography.dart` não são utilizados
- Comentário em `aggregate_root.dart` apresenta propostas (ADR-007) como fatos
- Botão da Home "Adicionar primeiro vinho" não reflete a jornada "Histórias"
- Branch `main` não recebe o trabalho da `develop` desde o início do domínio
