import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'О приложении',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(Icons.local_cafe, size: 80, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'CoffeeMate ☕',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Версия 1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Описание:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'CoffeeMate — это современное мобильное приложение, '
                'созданное для любителей кофе. Оно помогает находить '
                'лучшие кофейни поблизости, отслеживать любимые напитки '
                'и открывать новые вкусы. Приложение объединяет комфорт, '
                'удобство и эстетику кофейной культуры в одном месте.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 25),
              const Text(
                'Особенности:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Умный поиск кофеен по карте\n'
                '• Персональные рекомендации\n'
                '• Добавление любимых напитков в избранное\n'
                '• Возможность оценки кофеен и напитков\n'
                '• Удобный интерфейс и навигация',
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  '© 2025 CoffeeMate Team\nВсе права защищены',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
