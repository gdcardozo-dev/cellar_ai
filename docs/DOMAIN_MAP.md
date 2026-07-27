# Cellar AI - Domain Map

## Visão

O Cellar AI é composto por quatro grandes contextos de negócio.

Eles evoluem de forma independente, mas compartilham uma linguagem comum.

---

# 1. Wine Catalog

Responsável pelo conhecimento objetivo sobre vinhos.

Não contém informações pessoais.

## Aggregate Roots

- Wine

## Reference Entities

- Producer
- Country
- Region
- Grape

## Value Objects

- Package
- PackageSize
- GrapeComposition

## Enums

- PackageType
- ClosureType
- WineStyle
- VarietalStructure

---

# 2. User Cellar

Representa a coleção do usuário.

## Aggregate Roots

- Bottle

Entidades futuras:

- Purchase
- StorageLocation

---

# 3. Experiences

Representa momentos vividos.

## Aggregate Roots

- Story (MVP)

Evolução futura:

- Experience

---

# 4. Sommelier AI

Representa conhecimento interpretativo.

Não altera o domínio.

Consome informações do Wine Catalog e da User Cellar para gerar recomendações.

---

# Regra Fundamental

Wine Catalog representa fatos.

User Cellar representa propriedade.

Experiences representam memórias.

Sommelier AI representa interpretação.