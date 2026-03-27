import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/ingredient.dart';
import '../../models/recipe.dart';

class RecipeRepository {
  final SupabaseClient _client;

  RecipeRepository(this._client);

  Future<RecommendationResponse> getRecommendations(
    List<UserIngredient> ingredients,
  ) async {
    final body = {
      'ingredients': ingredients
          .map((i) => <String, Object>{
                'name': i.name,
                'quantity': i.quantity,
                'unit': i.unit,
              })
          .toList(),
    };

    final response = await _client.functions.invoke(
      'recommend',
      body: body,
    );

    if (response.status != 200) {
      final errorData = response.data as Map<String, dynamic>?;
      final message = errorData?['error'] as String? ?? '추천 요청에 실패했습니다';
      throw Exception(message);
    }

    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    return RecommendationResponse.fromJson(data);
  }
}
