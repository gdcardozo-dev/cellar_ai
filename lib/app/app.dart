import 'package:flutter/material.dart';

import 'home_page.dart';
import 'theme.dart';

class CellarAIApp extends StatelessWidget {
  const CellarAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cellar AI',
      debugShowCheckedModeBanner: false,
      theme: CellarTheme.light(),
      home: const HomePage(),
    );
  }
}