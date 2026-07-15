import 'package:flutter/material.dart';

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
                const SizedBox(height: 24),
                Text(
                  'Cellar AI',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'Seu assistente inteligente para amantes do vinho',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Minha Adega'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}