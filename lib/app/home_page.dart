import 'package:flutter/material.dart';

import 'package:cellar_ai/design/tokens/spacing.dart';
import 'package:cellar_ai/shared/widgets/cellar_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🍷',
                  style: TextStyle(fontSize: 72),
                ),

                SizedBox(height: CellarSpacing.lg),

                Text(
                  'Cellar AI',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                SizedBox(height: CellarSpacing.sm),

                Text(
                  'Seu assistente inteligente para amantes do vinho',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                SizedBox(height: CellarSpacing.xl),

                CellarButton(
                  label: 'Minha Adega',
                  onPressed: () {
                    debugPrint('Minha Adega');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}