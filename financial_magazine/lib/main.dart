import 'package:financial_magazine/screens/financial_magazine_data_screen.dart';
import 'package:financial_magazine/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'financial magazine',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const StatisticsScreen(),
        '/transactions': (context) => const FinancialMagazineDataScreen(),
      },
    );
  }
}
