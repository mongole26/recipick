/// 재료 카테고리 (단위 결정에 사용)
enum IngredientCategory {
  solid,
  liquid,
  countable,
  spice,
  powder,
  sheet,
  bunch,
}

/// 재료 정보
class IngredientInfo {
  final String name;
  final IngredientCategory category;
  final List<String> keywords;

  const IngredientInfo({
    required this.name,
    required this.category,
    this.keywords = const [],
  });
}

/// 사용자가 입력한 재료
class UserIngredient {
  final String name;
  final double quantity;
  final String unit;

  const UserIngredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  UserIngredient copyWith({String? name, double? quantity, String? unit}) {
    return UserIngredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }
}
