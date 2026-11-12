import 'package:cellar_ai/core/domain/foundation/domain_exception.dart';
import 'package:cellar_ai/core/domain/value_objects/alcohol_content.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlcoholContent', () {
    test('deve aceitar valores válidos', () {
      expect(AlcoholContent(0).percentage, 0);
      expect(AlcoholContent(13.5).percentage, 13.5);
    });

    test('deve recusar valores fora de 0 a 100', () {
      expect(() => AlcoholContent(-1), throwsA(isA<DomainException>()));
      expect(() => AlcoholContent(101), throwsA(isA<DomainException>()));
    });

    test('deve formatar com uma casa decimal', () {
      expect(AlcoholContent(13.5).toString(), '13.5%');
    });
  });
}
