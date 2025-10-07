import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const PWRVMApp());
}

class PWRVMApp extends StatelessWidget {
  const PWRVMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PWRVM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashScreen(),
    );
  }
}
