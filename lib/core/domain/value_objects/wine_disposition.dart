/// Destino de um vinho em uma história (ADR-030).
enum WineDisposition {
  /// O vinho foi bebido (padrão).
  consumed,

  /// A garrafa foi dada de presente; o usuário não provou o vinho.
  gifted,
}
