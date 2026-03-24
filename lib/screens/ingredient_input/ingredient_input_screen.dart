import 'package:flutter/material.dart';
import '../../data/ingredients_data.dart';
import '../../models/ingredient.dart';
import '../../utils/constants.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/recipick_bottom_sheet.dart';
import '../../widgets/common/recipick_button.dart';
import '../../widgets/common/recipick_card.dart';
import '../../widgets/common/recipick_chip.dart';
import '../../widgets/common/recipick_input.dart';

class IngredientInputScreen extends StatefulWidget {
  const IngredientInputScreen({super.key});

  @override
  State<IngredientInputScreen> createState() => _IngredientInputScreenState();
}

class _IngredientInputScreenState extends State<IngredientInputScreen> {
  final List<UserIngredient> _ingredients = [];
  final _searchController = TextEditingController();
  List<IngredientInfo> _suggestions = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _suggestions = searchIngredients(query);
      _isSearching = query.isNotEmpty;
    });
  }

  void _onIngredientSelected(IngredientInfo info) {
    _searchController.clear();
    setState(() {
      _suggestions = [];
      _isSearching = false;
    });
    _showQuantityBottomSheet(info);
  }

  void _showQuantityBottomSheet(IngredientInfo info) {
    final units = getUnitsForIngredient(info.name);
    String selectedUnit = units.first;
    final qtyController = TextEditingController();

    showRecipickBottomSheet(
      context: context,
      builder: (ctx, setSheetState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              info.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '수량과 단위를 선택해 주세요',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            RecipickInput(
              controller: qtyController,
              hintText: '수량 입력',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: units.map((unit) {
                return RecipickChip(
                  label: unit,
                  isSelected: selectedUnit == unit,
                  onTap: () => setSheetState(() => selectedUnit = unit),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            RecipickButton(
              label: '추가하기',
              onPressed: () {
                final qty = double.tryParse(qtyController.text);
                if (qty == null || qty <= 0) return;
                setState(() {
                  _ingredients.add(UserIngredient(
                    name: info.name,
                    quantity: qty,
                    unit: selectedUnit,
                  ));
                });
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }

  void _removeIngredient(int index) {
    setState(() => _ingredients.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text(
          '냉장고 재료 등록',
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
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(kPaddingPage, 8, kPaddingPage, 12),
            child: RecipickInput(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: '재료명을 검색하세요',
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              suffixIcon: _isSearching
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      child: Icon(Icons.close, color: Colors.grey[400]),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: _isSearching ? _buildSuggestionList() : _buildIngredientList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionList() {
    if (_suggestions.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        iconSize: 48,
        title: '검색 결과가 없습니다',
      );
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _suggestions.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        indent: 56,
        color: kDivider,
      ),
      itemBuilder: (context, index) {
        final info = _suggestions[index];
        return ListTile(
          tileColor: Colors.white,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(kRadiusIcon),
            ),
            child: const Icon(Icons.restaurant, color: kPrimaryColor, size: kIconSizeSm),
          ),
          title: Text(
            info.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: kTextPrimary,
            ),
          ),
          subtitle: info.keywords.isNotEmpty
              ? Text(
                  info.keywords.take(3).join(', '),
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                )
              : null,
          trailing: const Icon(Icons.add_circle_outline, color: kPrimaryColor),
          onTap: () => _onIngredientSelected(info),
        );
      },
    );
  }

  Widget _buildIngredientList() {
    if (_ingredients.isEmpty) {
      return const EmptyState(
        icon: Icons.kitchen,
        title: '냉장고가 비어있어요',
        subtitle: '위 검색창에서 재료를 추가해 보세요',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(kPaddingPage),
      itemCount: _ingredients.length,
      itemBuilder: (context, index) {
        final item = _ingredients[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _removeIngredient(index),
          background: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: kError,
              borderRadius: BorderRadius.circular(kRadiusCard),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          child: RecipickCard(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kPrimaryLight,
                    borderRadius: BorderRadius.circular(kRadiusIconLg),
                  ),
                  child: const Icon(Icons.restaurant, color: kPrimaryColor, size: kIconSizeMd),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatQuantity(item.quantity)} ${item.unit}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _removeIngredient(index),
                  child: Icon(Icons.close, size: 20, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatQuantity(double qty) {
    return qty == qty.roundToDouble() ? qty.toInt().toString() : qty.toString();
  }
}
