import 'package:flutter/material.dart';
import 'package:todo_project/data/functions.dart';
import 'package:todo_project/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}