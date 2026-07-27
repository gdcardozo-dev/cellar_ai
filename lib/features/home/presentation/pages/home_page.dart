import 'package:flutter/material.dart';

import 'package:cellar_ai/design/tokens/spacing.dart';
import 'package:cellar_ai/shared/widgets/cellar_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              Text(
                'Boa noite, Gustavo 🍷',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: CellarSpacing.sm),

              Text(
                'Hoje é um ótimo dia para abrir um grande vinho.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              SizedBox(height: CellarSpacing.xxl),

              _buildCard(
                context,
                icon: Icons.wine_bar,
                title: 'Sua Adega',
                subtitle:
                    'Sua adega está esperando sua primeira história.',
              ),

              SizedBox(height: CellarSpacing.lg),

              _buildCard(
                context,
                icon: Icons.auto_awesome,
                title: 'Hoje eu abriria...',
                subtitle:
                    'Quando sua adega crescer, eu farei recomendações personalizadas.',
              ),

              SizedBox(height: CellarSpacing.lg),

              _buildCard(
                context,
                icon: Icons.menu_book,
                title: 'Última História',
                subtitle:
                    'Suas melhores lembranças com vinho aparecerão aqui.',
              ),

              SizedBox(height: CellarSpacing.xxl),

              CellarButton(
                label: 'Adicionar primeiro vinho',
                onPressed: () {
                  debugPrint('Adicionar primeiro vinho');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 8),

                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}