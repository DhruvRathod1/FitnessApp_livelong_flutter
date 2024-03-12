import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:livelong_flutter/meal.dart';
import 'onboarding_screen.dart';
import 'meal_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MealPage(),
    );
  }
}
