/// 추천 레시피 결과 모델
class RecipeRecommendation {
  final String recipeId;
  final String title;
  final String? description;
  final int? cookTime;
  final String? difficulty;
  final int? servings;
  final String? imageUrl;
  final double matchRate;
  final List<String> matchedIngredients;
  final List<MissingIngredient> missingIngredients;
  final String aiReason;

  const RecipeRecommendation({
    required this.recipeId,
    required this.title,
    this.description,
    this.cookTime,
    this.difficulty,
    this.servings,
    this.imageUrl,
    required this.matchRate,
    required this.matchedIngredients,
    required this.missingIngredients,
    required this.aiReason,
  });

  factory RecipeRecommendation.fromJson(Map<String, dynamic> json) {
    return RecipeRecommendation(
      recipeId: json['recipe_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      cookTime: json['cook_time'] as int?,
      difficulty: json['difficulty'] as String?,
      servings: json['servings'] as int?,
      imageUrl: json['image_url'] as String?,
      matchRate: (json['match_rate'] as num).toDouble(),
      matchedIngredients: (json['matched_ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      missingIngredients: (json['missing_ingredients'] as List<dynamic>)
          .map((e) => MissingIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiReason: json['ai_reason'] as String,
    );
  }

  int get matchPercent => (matchRate * 100).round();

  String get cookTimeText => cookTime != null ? '$cookTime분' : '';
}

/// 부족한 재료
class MissingIngredient {
  final String name;
  final double? quantity;
  final String? unit;

  const MissingIngredient({
    required this.name,
    this.quantity,
    this.unit,
  });

  factory MissingIngredient.fromJson(Map<String, dynamic> json) {
    return MissingIngredient(
      name: json['name'] as String,
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );
  }

  String get displayText {
    if (quantity != null && unit != null) {
      final qtyStr = quantity == quantity!.roundToDouble()
          ? quantity!.toInt().toString()
          : quantity.toString();
      return '$name $qtyStr$unit';
    }
    return name;
  }
}

/// 레시피 재료 항목
class RecipeIngredientItem {
  final String name;
  final double? quantity;
  final String? unit;

  const RecipeIngredientItem({
    required this.name,
    this.quantity,
    this.unit,
  });

  String get displayText {
    if (quantity != null && unit != null) {
      final qtyStr = quantity == quantity!.roundToDouble()
          ? quantity!.toInt().toString()
          : quantity.toString();
      return '$name $qtyStr$unit';
    }
    return name;
  }
}

/// 레시피 상세 정보
class RecipeDetail {
  final String id;
  final String title;
  final String? description;
  final int? cookTime;
  final String? difficulty;
  final int? servings;
  final String? imageUrl;
  final List<CookingStep> instructions;
  final List<RecipeIngredientItem> ingredients;

  const RecipeDetail({
    required this.id,
    required this.title,
    this.description,
    this.cookTime,
    this.difficulty,
    this.servings,
    this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(
    Map<String, dynamic> json,
    List<RecipeIngredientItem> ingredients,
  ) {
    final rawInstructions = json['instructions'] as List<dynamic>? ?? [];
    return RecipeDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      cookTime: json['cook_time'] as int?,
      difficulty: json['difficulty'] as String?,
      servings: json['servings'] as int?,
      imageUrl: json['image_url'] as String?,
      instructions: rawInstructions
          .map((e) => CookingStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      ingredients: ingredients,
    );
  }

  String get cookTimeText => cookTime != null ? '$cookTime분' : '';
}

/// 조리 순서 단계
class CookingStep {
  final int step;
  final String text;

  const CookingStep({required this.step, required this.text});

  factory CookingStep.fromJson(Map<String, dynamic> json) {
    return CookingStep(
      step: json['step'] as int,
      text: json['text'] as String,
    );
  }
}

/// Edge Function 전체 응답
class RecommendationResponse {
  final List<RecipeRecommendation> recommendations;

  const RecommendationResponse({required this.recommendations});

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationResponse(
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => RecipeRecommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
