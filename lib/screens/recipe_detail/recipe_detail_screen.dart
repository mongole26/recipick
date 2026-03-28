import 'package:flutter/material.dart';
import '../../config/supabase_config.dart';
import '../../data/repositories/recipe_repository.dart';
import '../../models/recipe.dart';
import '../../utils/constants.dart';
import '../../widgets/common/recipick_card.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeRecommendation recommendation;

  const RecipeDetailScreen({super.key, required this.recommendation});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  RecipeDetail? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final repo = RecipeRepository(supabase);
      final detail = await repo.getRecipeDetail(widget.recommendation.recipeId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recommendation;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: Text(
          r.title,
          style: const TextStyle(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('불러오기 실패', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _error = null;
                          });
                          _loadDetail();
                        },
                        child: const Text('다시 시도'),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final r = widget.recommendation;
    final detail = _detail!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(kPaddingPage),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 기본 정보 카드
          RecipickCard(
            padding: const EdgeInsets.all(kPaddingPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (r.description != null) ...[
                  Text(
                    r.description!,
                    style: const TextStyle(fontSize: 15, color: kTextSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                ],
                Row(
                  children: [
                    _MetaChip(icon: Icons.schedule, label: detail.cookTimeText),
                    const SizedBox(width: 8),
                    if (detail.difficulty != null)
                      _MetaChip(icon: Icons.local_fire_department, label: detail.difficulty!),
                    const SizedBox(width: 8),
                    if (detail.servings != null)
                      _MetaChip(icon: Icons.people_outline, label: '${detail.servings}인분'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // AI 추천 이유
          RecipickCard(
            padding: const EdgeInsets.all(kPaddingPage),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, size: 18, color: kPrimaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.matchPercent}% 재료 일치',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        r.aiReason,
                        style: const TextStyle(fontSize: 14, color: kTextSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 재료 섹션
          const Text(
            '재료',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kTextPrimary),
          ),
          const SizedBox(height: 10),
          RecipickCard(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingPage, vertical: 8),
            child: Column(
              children: detail.ingredients.map((ing) {
                final isMatched = r.matchedIngredients.contains(ing.name);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        isMatched ? Icons.check_circle : Icons.circle_outlined,
                        size: 20,
                        color: isMatched ? kSuccess : kWarning,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ing.name,
                          style: TextStyle(
                            fontSize: 15,
                            color: isMatched ? kTextPrimary : kTextSecondary,
                            fontWeight: isMatched ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (ing.quantity != null && ing.unit != null)
                        Text(
                          ing.displayText.replaceFirst(ing.name, '').trim(),
                          style: const TextStyle(fontSize: 14, color: kTextHint),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // 조리 순서 섹션
          const Text(
            '조리 순서',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kTextPrimary),
          ),
          const SizedBox(height: 10),
          ...detail.instructions.map((step) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${step.step}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        step.text,
                        style: const TextStyle(
                          fontSize: 15,
                          color: kTextPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kInputFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: kTextSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: kTextSecondary),
          ),
        ],
      ),
    );
  }
}
