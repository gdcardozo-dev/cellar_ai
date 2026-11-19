# Cellar AI — Visão do Produto

> Fonte oficial da visão (ADR-013). Contém apenas o que já foi aprovado.
> A versão anterior, orientada a gestão de adega, está em `docs/historico/VISION_v0.md`.

## Lema

**Cada garrafa conta uma história.**

## Visão — APROVADA (ADR-001)

O Cellar AI é um companheiro inteligente para **preservar, conectar e redescobrir experiências e memórias relacionadas a vinho**.

Na formulação do responsável pelo produto:

> *"Um assistente que preserva e conecta minhas melhores experiências com vinho."*

O valor central está nos momentos, nas pessoas, nos lugares e nos vinhos que fizeram parte deles. O controle da adega é uma capacidade complementar, não a identidade do produto.

## Experiência — APROVADA

- **Mensagem de abertura:** "Hoje é um ótimo dia para abrir um grande vinho."
- **Jornada principal:** Histórias.
- **Linguagem:** simples e clara, com pouca terminologia enológica; experiência intuitiva.
- **Tema visual:** light mode inicialmente; dark mode posteriormente.

## Inteligência Artificial — DIREÇÃO

A IA interpreta dados de catálogo e registros pessoais para responder perguntas sobre experiências e preferências (ver `QUESTIONS_THE_AI_MUST_ANSWER.md`).

- Diferenciar fatos fornecidos pelo usuário de inferências.
- Nunca inventar lembranças.
- Definir autorização, consentimento e retenção antes de explorar dados sensíveis de pessoas e locais.

## Ideias futuras — NÃO PLANEJADAS

- **Wine Concierge:** interpretar cartas de vinho de restaurantes e sugerir harmonizações para entrada, prato principal e sobremesa.

## Prioridade e MVP — APROVADOS (ADR-023)

- **Histórias** é a identidade do produto; **Adega** é a porta de entrada.
- O MVP ajuda o usuário a: saber quais vinhos possui; acompanhar custo e valor estimado da coleção; identificar o momento de consumo de cada garrafa; e registrar histórias quando uma garrafa é aberta ou presenteada.
- Proposta de experiência: mais simples, intuitiva e pessoal que aplicativos de rede social de vinhos; linguagem acessível.
- Dados confiáveis antes de respostas aparentemente completas: sugestões são sempre identificadas como tal (ADR-027).
- Cadastro assistido por IA, relatório em PDF e recomendações por ocasião ficam para a próxima versão (ADR-028). Plano completo em `docs/PRODUCT_EVOLUTION_PLAN.md`.

## A definir

Público-alvo e modelo de negócio (há intenção de viabilidade comercial e monetização futura, ainda sem decisão). A versão anterior desses itens está em `docs/historico/VISION_v0.md`, apenas como referência.
