/// Dados do vinho que podem chegar como sugestão e ser enriquecidos
/// progressivamente (ADR-027, ADR-033).
///
/// Produtor, nome e safra não estão aqui: a identidade é sempre
/// confirmada.
enum WineEnrichment { region, grapes, alcoholContent, drinkingWindow }
