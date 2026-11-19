import '../foundation/domain_exception.dart';
import '../foundation/optional_text.dart';

/// Foto de uma história (ADR-017).
///
/// [reference] identifica o arquivo; onde e como ele é guardado é
/// responsabilidade da camada de infraestrutura, não do domínio.
final class Photo {
  Photo({required String reference, String? caption})
    : reference = reference.trim(),
      caption = cleanOptionalText(caption) {
    if (this.reference.isEmpty) {
      throw const DomainException('A referência da foto não pode ser vazia.');
    }
  }

  final String reference;
  final String? caption;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo &&
          other.reference == reference &&
          other.caption == caption;

  @override
  int get hashCode => Object.hash(reference, caption);

  @override
  String toString() => caption ?? reference;
}
