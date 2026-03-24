import 'package:flutter/material.dart';
import '../data/ingredients_data.dart';
import '../models/ingredient.dart';

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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 핸들바
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 재료명
                      Text(
                        info.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '수량과 단위를 선택해 주세요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 수량 입력
                      TextField(
                        controller: qtyController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: '수량 입력',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF5F0080),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 단위 선택 칩
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: units.map((unit) {
                          final isSelected = selectedUnit == unit;
                          return GestureDetector(
                            onTap: () {
                              setSheetState(() => selectedUnit = unit);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF5F0080)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF5F0080)
                                      : const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                unit,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF666666),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),

                      // 추가 버튼
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5F0080),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('추가하기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text(
          '냉장고 재료 등록',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Color(0xFF333333),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: Column(
        children: [
          // 검색 바
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: '재료명을 검색하세요',
                hintStyle: TextStyle(color: Colors.grey[400]),
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
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 본문
          Expanded(
            child: _isSearching ? _buildSuggestionList() : _buildIngredientList(),
          ),
        ],
      ),
    );
  }

  /// 검색 자동완성 리스트
  Widget _buildSuggestionList() {
    if (_suggestions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              '검색 결과가 없습니다',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: _suggestions.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        indent: 56,
        color: Color(0xFFF0F0F0),
      ),
      itemBuilder: (context, index) {
        final info = _suggestions[index];
        return ListTile(
          tileColor: Colors.white,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.restaurant,
              color: Color(0xFF5F0080),
              size: 20,
            ),
          ),
          title: Text(
            info.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          subtitle: info.keywords.isNotEmpty
              ? Text(
                  info.keywords.take(3).join(', '),
                  style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                )
              : null,
          trailing: const Icon(
            Icons.add_circle_outline,
            color: Color(0xFF5F0080),
          ),
          onTap: () => _onIngredientSelected(info),
        );
      },
    );
  }

  /// 등록된 재료 리스트
  Widget _buildIngredientList() {
    if (_ingredients.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.kitchen, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              '냉장고가 비어있어요',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '위 검색창에서 재료를 추가해 보세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
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
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Color(0xFF5F0080),
                    size: 22,
                  ),
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
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatQuantity(item.quantity)} ${item.unit}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5F0080),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _removeIngredient(index),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.grey[400],
                  ),
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
