# Cellar AI — Backlog

## Sprint 0 — Fundação e Domain Blueprint

### Concluído
- [x] Revisão de `pubspec.yaml`, `analysis_options.yaml` e análise estática
- [x] Revisão de `EntityId`, `Entity` e `AggregateRoot`
- [x] Remoção do arquivo órfão `entity_id.freezed.dart` e formatação do código
- [x] Documentos de transferência adicionados ao repositório
- [x] Passo 0 — organização da documentação (ADR-013)

### Próximas decisões do Domain Blueprint
- [ ] Decisão 1 — Identidade de `Wine` (rótulo, safra, NV × safra desconhecida)
- [ ] Decisão 2 — A que uma `Story` se refere (vinho de catálogo, garrafa física, "vinho bebido")
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
