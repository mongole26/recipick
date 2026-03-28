import 'package:flutter_test/flutter_test.dart';
import 'package:recipick/models/recipe.dart';

void main() {
  group('RecipeRecommendation', () {
    test('fromJson parses correctly', () {
      final json = {
        'recipe_id': 'abc-123',
        'title': '김치찌개',
        'description': '맛있는 김치찌개',
        'cook_time': 25,
        'difficulty': '쉬움',
        'servings': 2,
        'image_url': null,
        'match_rate': 0.78,
        'matched_ingredients': ['돼지고기', '양파'],
        'missing_ingredients': [
          {'name': '두부', 'quantity': 0.5, 'unit': '개'},
          {'name': '대파', 'quantity': 1, 'unit': '단'},
        ],
        'ai_reason': '보유한 재료로 간단하게 만들 수 있어요',
      };

      final r = RecipeRecommendation.fromJson(json);

      expect(r.recipeId, 'abc-123');
      expect(r.title, '김치찌개');
      expect(r.description, '맛있는 김치찌개');
      expect(r.cookTime, 25);
      expect(r.difficulty, '쉬움');
      expect(r.servings, 2);
      expect(r.imageUrl, isNull);
      expect(r.matchRate, 0.78);
      expect(r.matchedIngredients, ['돼지고기', '양파']);
      expect(r.missingIngredients.length, 2);
      expect(r.aiReason, '보유한 재료로 간단하게 만들 수 있어요');
    });

    test('matchPercent rounds correctly', () {
      final r = RecipeRecommendation(
        recipeId: '1',
        title: 'test',
        matchRate: 0.786,
        matchedIngredients: const [],
        missingIngredients: const [],
        aiReason: '',
      );
      expect(r.matchPercent, 79);
    });

    test('cookTimeText formats correctly', () {
      final withTime = RecipeRecommendation(
        recipeId: '1',
        title: 'test',
        cookTime: 20,
        matchRate: 0,
        matchedIngredients: const [],
        missingIngredients: const [],
        aiReason: '',
      );
      expect(withTime.cookTimeText, '20분');

      final noTime = RecipeRecommendation(
        recipeId: '1',
        title: 'test',
        matchRate: 0,
        matchedIngredients: const [],
        missingIngredients: const [],
        aiReason: '',
      );
      expect(noTime.cookTimeText, '');
    });
  });

  group('MissingIngredient', () {
    test('fromJson parses correctly', () {
      final json = {'name': '두부', 'quantity': 0.5, 'unit': '개'};
      final m = MissingIngredient.fromJson(json);

      expect(m.name, '두부');
      expect(m.quantity, 0.5);
      expect(m.unit, '개');
    });

    test('displayText formats with quantity and unit', () {
      const m = MissingIngredient(name: '간장', quantity: 15, unit: 'ml');
      expect(m.displayText, '간장 15ml');
    });

    test('displayText formats decimal quantity', () {
      const m = MissingIngredient(name: '두부', quantity: 0.5, unit: '개');
      expect(m.displayText, '두부 0.5개');
    });

    test('displayText returns name only when no quantity', () {
      const m = MissingIngredient(name: '소금');
      expect(m.displayText, '소금');
    });
  });

  group('CookingStep', () {
    test('fromJson parses correctly', () {
      final json = {'step': 1, 'text': '양파를 잘게 썰어주세요'};
      final step = CookingStep.fromJson(json);

      expect(step.step, 1);
      expect(step.text, '양파를 잘게 썰어주세요');
    });
  });

  group('RecipeIngredientItem', () {
    test('displayText with quantity and unit', () {
      const item = RecipeIngredientItem(name: '돼지고기', quantity: 300, unit: 'g');
      expect(item.displayText, '돼지고기 300g');
    });

    test('displayText with decimal quantity', () {
      const item = RecipeIngredientItem(name: '두부', quantity: 0.5, unit: '개');
      expect(item.displayText, '두부 0.5개');
    });

    test('displayText name only', () {
      const item = RecipeIngredientItem(name: '소금');
      expect(item.displayText, '소금');
    });
  });

  group('RecommendationResponse', () {
    test('fromJson parses list of recommendations', () {
      final json = {
        'recommendations': [
          {
            'recipe_id': '1',
            'title': '김치찌개',
            'description': null,
            'cook_time': 25,
            'difficulty': '쉬움',
            'servings': 2,
            'image_url': null,
            'match_rate': 0.8,
            'matched_ingredients': ['김치'],
            'missing_ingredients': <Map<String, dynamic>>[],
            'ai_reason': '좋아요',
          },
        ],
      };

      final response = RecommendationResponse.fromJson(json);
      expect(response.recommendations.length, 1);
      expect(response.recommendations[0].title, '김치찌개');
    });

    test('fromJson handles empty recommendations', () {
      final json = {'recommendations': <Map<String, dynamic>>[]};
      final response = RecommendationResponse.fromJson(json);
      expect(response.recommendations, isEmpty);
    });
  });
}
