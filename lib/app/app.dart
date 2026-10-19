import 'package:flutter/material.dart';

import 'package:cellar_ai/design/theme/light_theme.dart';
import 'package:cellar_ai/features/home/presentation/pages/home_page.dart';

class CellarApp extends StatelessWidget {
  const CellarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cellar AI',
      debugShowCheckedModeBanner: false,
      theme: CellarLightTheme.theme,
      home: const HomePage(),
    );
  }
}
