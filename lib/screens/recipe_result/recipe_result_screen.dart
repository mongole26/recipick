import 'package:flutter/material.dart';
import '../../models/recipe.dart';
import '../../utils/constants.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/recipick_card.dart';
import '../recipe_detail/recipe_detail_screen.dart';

class RecipeResultScreen extends StatelessWidget {
  final List<RecipeRecommendation> recommendations;

  const RecipeResultScreen({super.key, required this.recommendations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          '추천 레시피',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: kTextPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: recommendations.isEmpty
          ? const EmptyState(
              icon: Icons.restaurant_menu,
              title: '추천할 레시피가 없습니다',
              subtitle: '다른 재료를 추가해 보세요',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(kPaddingPage),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                return _RecipeCard(
                  recommendation: recommendations[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(
                          recommendation: recommendations[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final RecipeRecommendation recommendation;
  final VoidCallback onTap;

  const _RecipeCard({required this.recommendation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = recommendation;
    return GestureDetector(
      onTap: onTap,
      child: RecipickCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(kPaddingPage),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 레시피 이름 + 화살표
            Row(
              children: [
                Expanded(
                  child: Text(
                    r.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kTextPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: kTextHint, size: 24),
              ],
            ),

            // 설명
            if (r.description != null) ...[
              const SizedBox(height: 4),
              Text(
                r.description!,
                style: const TextStyle(fontSize: 14, color: kTextSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            // 조리시간 + 난이도
            Row(
              children: [
                if (r.cookTime != null) ...[
                  const Icon(Icons.schedule, size: 16, color: kTextHint),
                  const SizedBox(width: 4),
                  Text(
                    r.cookTimeText,
                    style: const TextStyle(fontSize: 13, color: kTextSecondary),
                  ),
                  const SizedBox(width: 12),
                ],
                if (r.difficulty != null) ...[
                  const Icon(Icons.local_fire_department, size: 16, color: kTextHint),
                  const SizedBox(width: 4),
                  Text(
                    r.difficulty!,
                    style: const TextStyle(fontSize: 13, color: kTextSecondary),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // 매칭률 프로그레스바
            _MatchRateBar(matchPercent: r.matchPercent),

            const SizedBox(height: 12),

            // 부족한 재료
            if (r.missingIngredients.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: kWarning),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '부족: ${r.missingIngredients.map((m) => m.name).join(", ")}',
                      style: const TextStyle(fontSize: 13, color: kWarning),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // AI 추천 이유
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryFaint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, size: 16, color: kPrimaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      r.aiReason,
                      style: const TextStyle(
                        fontSize: 13,
                        color: kPrimaryColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchRateBar extends StatelessWidget {
  final int matchPercent;

  const _MatchRateBar({required this.matchPercent});

  Color get _barColor {
    if (matchPercent >= 70) return kSuccess;
    if (matchPercent >= 40) return kWarning;
    return kTextHint;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '재료 일치율',
              style: TextStyle(fontSize: 12, color: kTextSecondary),
            ),
            Text(
              '$matchPercent%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _barColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: matchPercent / 100,
            minHeight: 6,
            backgroundColor: kInputFill,
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
          ),
        ),
      ],
    );
  }
}
