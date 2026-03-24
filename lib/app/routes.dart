import 'package:flutter/material.dart';
import '../screens/ingredient_input/ingredient_input_screen.dart';

class Routes {
  static const String ingredientInput = '/ingredient-input';

  static Map<String, WidgetBuilder> get all => {
    ingredientInput: (_) => const IngredientInputScreen(),
  };
}
