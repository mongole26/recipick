import 'package:flutter/material.dart';
import 'app/app.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabase();
  runApp(const RecipickApp());
}
