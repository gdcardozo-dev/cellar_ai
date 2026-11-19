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
- [x] Passo 2 — `Money` (centavos + moeda), `Quantity`, `AlcoholContent`, `PackageSize` e entidades de catálogo com `DomainException`, com testes
- [x] Passo 3 — `Region` e `GrapeComposition` passam a guardar apenas ids (ADR-019), com testes
- [x] Passo 4 — Novo `Wine` como Aggregate Root (identidade, `WineType`, regras de uvas), com testes
  - Avaliar hierarquia de regiões (região-mãe, ex.: Mendoza → Luján de Cuyo) — proposta, ainda não decidida
- [ ] Caso de uso "Cadastrar vinho" (impede duplicatas no catálogo) — junto com a camada de aplicação
- [x] Passo 5 — `Person` e `Place` (ADR-022); catálogo estende `AggregateRoot`, com testes
- [ ] Caso de uso "Cadastrar pessoa" (impede duplicatas pelo nome normalizado)
- [x] Passo 6 — `Story` e `StoryWine` (ADR-016, ADR-025, ADR-030), com `Rating`, `Photo`, `Dish` e testes
- [x] Passo 7 — `CellarLot` e `Acquisition` (ADR-026, ADR-031), com `CellarRemoval` e testes

**Sprint 0 concluída em 18/11/2026.**

## Sprint 1 — Valor, tempo e dados reais (ver `PRODUCT_EVOLUTION_PLAN.md`)
- [x] Procedência dos dados: `Provenance` e `Sourced<T>` (ADR-027), com testes
- [x] `MarketValuation` com histórico e estimativa vigente (ADR-032), com testes
- [x] `DrinkingWindow` e status de consumo por regras explícitas (ADR-032), com testes
- [x] Tipo de embalagem e código de lote do fabricante (ADR-033), com testes

**Sprint 1 concluída em 18/11/2026.**
- [x] Fixtures dos 12 vinhos reais (`test/fixtures/`) + testes de aceite (`test/acceptance/`)
- [x] `CollectionSummary`: lógica do painel simples (garrafas, países, custo pago e valor estimado por moeda)

## Sprints seguintes
- [x] Sprint 2 — Casos de uso com armazenamento em memória (ADR-034)
  - [x] Repositórios (contratos) e implementações em memória
  - [x] Caso de uso "Registrar história" (cria a Story e baixa os lotes, tudo ou nada)
  - [x] Procedência no `Wine` e `GrapeBlend` (ADR-035)
  - [x] Casos de uso "Cadastrar vinho" (sem duplicatas) e "Revisar sugestão" (ADR-035)
  - [x] "Registrar compra" (ADR-037), "Baixa avulsa" e "Cadastrar pessoa" (ADR-022)

**Sprint 2 concluída em 19/11/2026.**
- [ ] Sprint 3 — Persistência (decidir Firebase × banco local), com transação para operações que salvam mais de um agregado
- [ ] Sprint 4 — Telas do MVP

## Pendências técnicas identificadas (aguardando decisão)
- Flutter 3.47+ marca `package:flutter/material.dart` como obsoleto em favor do pacote `material_ui`; avaliar migração junto com a atualização da versão do Flutter (CI fixada em 3.44.6)
- Dependências Freezed/JSON no `pubspec.yaml` sem uso no código
- `lib/app/theme.dart` e `lib/design/typography.dart` não são utilizados
- Botão da Home "Adicionar primeiro vinho": reavaliar à luz da ADR-023 (Adega como porta de entrada) na Sprint 4
- Branch `main` não recebe o trabalho da `develop` desde o início do domínio
