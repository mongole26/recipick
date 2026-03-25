/// 레시피 임베딩 생성 스크립트 (Google Gemini)
///
/// 사용법: dart run scripts/generate_embeddings.dart
/// 필요: 프로젝트 루트에 .env 파일 (SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, GEMINI_API_KEY)

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// .env 파일에서 환경변수를 읽어 Map으로 반환
Map<String, String> loadEnv() {
  final file = File('.env');
  if (!file.existsSync()) {
    print('❌ .env 파일이 없습니다. .env.example을 참고하여 생성해주세요.');
    exit(1);
  }
  final lines = file.readAsLinesSync();
  final env = <String, String>{};
  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final idx = trimmed.indexOf('=');
    if (idx == -1) continue;
    env[trimmed.substring(0, idx)] = trimmed.substring(idx + 1);
  }
  return env;
}

Future<void> main() async {
  final env = loadEnv();
  final supabaseUrl = env['SUPABASE_URL'];
  final supabaseServiceKey = env['SUPABASE_SERVICE_ROLE_KEY'];
  final geminiApiKey = env['GEMINI_API_KEY'];

  if (supabaseUrl == null || supabaseServiceKey == null || geminiApiKey == null) {
    print('❌ .env에 SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, GEMINI_API_KEY가 필요합니다.');
    exit(1);
  }

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
    final recipeId = recipe['id'] as String;
    final title = recipe['title'] as String;

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
        .map((i) => (i as Map<String, dynamic>)['ingredients']?['name'] ?? '')
        .where((n) => (n as String).isNotEmpty)
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

    final embeddingData = jsonDecode(embeddingRes.body) as Map<String, dynamic>;
    final embeddingMap = embeddingData['embedding'] as Map<String, dynamic>;
    final embedding = embeddingMap['values'] as List;

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
