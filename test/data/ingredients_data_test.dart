import 'package:flutter_test/flutter_test.dart';
import 'package:recipick/data/ingredients_data.dart';

void main() {
  group('searchIngredients', () {
    test('returns empty list for empty query', () {
      final results = searchIngredients('');
      expect(results, isEmpty);
    });

    test('finds ingredient by exact name', () {
      final results = searchIngredients('양파');
      expect(results.any((i) => i.name == '양파'), isTrue);
    });

    test('finds ingredient by partial name', () {
      final results = searchIngredients('고기');
      expect(results.length, greaterThanOrEqualTo(3)); // 소고기, 돼지고기, 닭고기
    });

    test('finds ingredient by keyword', () {
      final results = searchIngredients('egg');
      expect(results.any((i) => i.name == '달걀'), isTrue);
    });

    test('returns empty for no match', () {
      final results = searchIngredients('존재하지않는재료xyz');
      expect(results, isEmpty);
    });
  });

  group('getUnitsForIngredient', () {
    test('returns correct units for solid ingredient', () {
      final units = getUnitsForIngredient('소고기');
      expect(units, contains('g'));
      expect(units, contains('kg'));
    });

    test('returns correct units for liquid ingredient', () {
      final units = getUnitsForIngredient('우유');
      expect(units, contains('ml'));
      expect(units, contains('L'));
    });

    test('returns correct units for countable ingredient', () {
      final units = getUnitsForIngredient('양파');
      expect(units, contains('개'));
    });

    test('returns fallback units for unknown ingredient', () {
      final units = getUnitsForIngredient('알수없는재료');
      expect(units, contains('g'));
      expect(units, contains('개'));
    });
  });

  group('ingredientDatabase', () {
    test('has sufficient entries', () {
      expect(ingredientDatabase.length, greaterThanOrEqualTo(60));
    });

    test('all ingredients have names', () {
      for (final ing in ingredientDatabase) {
        expect(ing.name, isNotEmpty);
      }
    });

    test('categoryUnits covers all categories', () {
      for (final cat in ingredientDatabase.map((i) => i.category).toSet()) {
        expect(categoryUnits.containsKey(cat), isTrue,
            reason: 'Missing units for category: $cat');
      }
    });
  });
}
