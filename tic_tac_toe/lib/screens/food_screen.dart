// lib/screens/food_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipe_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final String apiBase = 'http://172.20.10.2:3000';
  final TextEditingController _ingredientController = TextEditingController();

  List<String> selectedIngredients = [];
  List<Map<String, dynamic>> suggestedRecipes = [];
  bool loading = false;

  String meal = '';
  bool vegetarian = false;

  void _addIngredient(String text) {
    final val = text.trim().toLowerCase();
    if (val.isEmpty) return;
    if (!selectedIngredients.contains(val)) {
      setState(() => selectedIngredients.add(val));
    }
    _ingredientController.clear();
  }

  void _removeIngredient(String ing) {
    setState(() => selectedIngredients.remove(ing));
  }

  Future<void> _suggestRecipes() async {
    if (selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Добавьте хотя бы один ингредиент')),
      );
      return;
    }

    setState(() {
      loading = true;
      suggestedRecipes = [];
    });

    try {
      final resp = await http.post(
        Uri.parse('$apiBase/api/ai/suggest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ingredients': selectedIngredients,
          'preferences': {
            'meal': meal,
            'vegetarian': vegetarian,
          }
        }),
      );

      if (resp.statusCode == 200) {
        final List data = jsonDecode(resp.body);
        setState(() {
          suggestedRecipes = data.map<Map<String, dynamic>>((e) {
            return {
              'title': e['title'],
              'ingredients': List<String>.from(e['ingredients']),
              'steps': List<String>.from(e['steps']),
              'image': 'assets/images/food1.png',
            };
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сервера')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка подключения: $e')),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  void _openRecipe(Map<String, dynamic> recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeScreen(
          title: recipe['title'],
          imagePath: recipe['image'],
          ingredients: List<String>.from(recipe['ingredients']),
          steps: List<String>.from(recipe['steps']),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food AI — ИИ рецепты'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    onSubmitted: _addIngredient,
                    decoration: InputDecoration(
                      hintText: 'Введите ингредиент',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            _addIngredient(_ingredientController.text),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _suggestRecipes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('ИИ'),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 6,
              children: selectedIngredients.map((ing) {
                return Chip(
                  label: Text(ing),
                  onDeleted: () => _removeIngredient(ing),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                DropdownButton<String>(
                  value: meal.isEmpty ? null : meal,
                  hint: const Text('Приём пищи'),
                  items: const [
                    DropdownMenuItem(
                        value: 'breakfast', child: Text('Завтрак')),
                    DropdownMenuItem(value: 'lunch', child: Text('Обед')),
                    DropdownMenuItem(value: 'dinner', child: Text('Ужин')),
                  ],
                  onChanged: (v) => setState(() => meal = v ?? ''),
                ),
                const SizedBox(width: 16),
                Checkbox(
                  value: vegetarian,
                  onChanged: (v) => setState(() => vegetarian = v ?? false),
                ),
                const Text('Вегетарианство'),
              ],
            ),

            const Divider(),

            Expanded(
              child: suggestedRecipes.isEmpty
                  ? Center(
                      child: Text(
                        loading
                            ? 'ИИ генерирует рецепты...'
                            : 'Введите ингредиенты',
                      ),
                    )
                  : ListView.builder(
                      itemCount: suggestedRecipes.length,
                      itemBuilder: (context, index) {
                        final r = suggestedRecipes[index];
                        return Card(
                          child: ListTile(
                            title: Text(r['title']),
                            trailing: const Icon(Icons.open_in_new),
                            onTap: () => _openRecipe(r),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
