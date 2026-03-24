import 'package:flutter/material.dart';
import '../screens/ingredient_input/ingredient_input_screen.dart';
import '../utils/constants.dart';
import 'routes.dart';

class RecipickApp extends StatelessWidget {
  const RecipickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipick',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        scaffoldBackgroundColor: kBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
        ),
      ),
      home: const IngredientInputScreen(),
      routes: Routes.all,
    );
  }
}
