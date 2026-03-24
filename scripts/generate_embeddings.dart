/// 레시피 임베딩 생성 스크립트 (Google Gemini)
///
/// 사용법: dart run scripts/generate_embeddings.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// ========================================
// 설정
// ========================================
const supabaseUrl = 'https://tibyeamvajetfxxsknit.supabase.co';
const supabaseServiceKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRpYnllYW12YWpldGZ4eHNrbml0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NDM1NTQ1MywiZXhwIjoyMDg5OTMxNDUzfQ.l3aKql9gBoItZJZrSfpmjjn_4L5Kq5doSUYc-HwwePM';
const geminiApiKey = 'AIzaSyAFs8frrkeio4gEU1v3B6VTiveE0o-hNYk';

Future<void> main() async {
  print('📦 레시피 데이터 가져오는 중...');

  // 1. Supabase에서 레시피 조회
  final recipesRes = await http.get(
    Uri.parse('$supabaseUrl/rest/v1/recipes?select=id,title,description'),
    headers: {
      'apikey': supabaseServiceKey,
      'Authorization': 'Bearer $supabaseServiceKey',
    },
  );

  if (recipesRes.statusCode != 200) {
    print('❌ 레시피 조회 실패: ${recipesRes.body}');
    exit(1);
  }

  final recipes = jsonDecode(recipesRes.body) as List;
  print('✅ ${recipes.length}개 레시피 로드');

  var successCount = 0;
  var skipCount = 0;

  for (final recipe in recipes) {
    final recipeId = recipe['id'];
    final title = recipe['title'];

    // 이미 임베딩이 있는지 확인
    final existCheck = await http.get(
      Uri.parse(
        '$supabaseUrl/rest/v1/recipe_embeddings?recipe_id=eq.$recipeId',
      ),
      headers: {
        'apikey': supabaseServiceKey,
        'Authorization': 'Bearer $supabaseServiceKey',
      },
    );
    if ((jsonDecode(existCheck.body) as List).isNotEmpty) {
      skipCount++;
      continue;
    }

    // 재료 조회
    final ingredientsRes = await http.get(
      Uri.parse(
        '$supabaseUrl/rest/v1/recipe_ingredients?recipe_id=eq.$recipeId&select=quantity,unit,ingredients(name)',
      ),
      headers: {
        'apikey': supabaseServiceKey,
        'Authorization': 'Bearer $supabaseServiceKey',
      },
    );

    final ingredients = jsonDecode(ingredientsRes.body) as List;
    final ingredientNames = ingredients
        .map((i) => i['ingredients']?['name'] ?? '')
        .where((n) => n.isNotEmpty)
        .join(', ');

    final content =
        '$title ${recipe['description'] ?? ''} 재료: $ingredientNames';

    // 2. Gemini Embedding 생성
    final embeddingRes = await http.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-embedding-001:embedContent?key=$geminiApiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': 'models/gemini-embedding-001',
        'content': {
          'parts': [
            {'text': content}
          ]
        },
        'outputDimensionality': 768,
      }),
    );

    if (embeddingRes.statusCode != 200) {
      print('⚠️ [$title] 임베딩 생성 실패: ${embeddingRes.body}');
      continue;
    }

    final embeddingData = jsonDecode(embeddingRes.body);
    final embedding = embeddingData['embedding']['values'] as List;

    // 3. Supabase에 임베딩 저장
    final insertRes = await http.post(
      Uri.parse('$supabaseUrl/rest/v1/recipe_embeddings'),
      headers: {
        'apikey': supabaseServiceKey,
        'Authorization': 'Bearer $supabaseServiceKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: jsonEncode({
        'recipe_id': recipeId,
        'embedding': embedding.map((e) => (e as num).toDouble()).toList(),
        'content': content,
      }),
    );

    if (insertRes.statusCode == 201) {
      successCount++;
      print('✅ [$title] 임베딩 생성 완료');
    } else {
      print('⚠️ [$title] 저장 실패: ${insertRes.body}');
    }

    // Rate limit 방지
    await Future.delayed(const Duration(milliseconds: 300));
  }

  print('\n========================================');
  print('완료: $successCount개 생성, $skipCount개 스킵 (이미 존재)');
  print('========================================');
}
