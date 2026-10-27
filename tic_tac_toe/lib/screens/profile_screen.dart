import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/favorites.dart';
import 'recipe_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> favorites = [];
  String username = 'Загрузка...';
  late int userId;
  final String apiUrl = 'http://172.20.10.2:3000';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    if (id != null) {
      setState(() {
        userId = id;
      });
      _loadUserInfo();
      _loadFavorites();
    } else {
      setState(() {
        username = 'Ошибка: пользователь не найден';
      });
    }
  }

  Future<void> _loadUserInfo() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/users/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          username = data['name'] ?? 'Без имени';
        });
      } else {
        setState(() {
          username = 'Ошибка загрузки';
        });
      }
    } catch (e) {
      setState(() {
        username = 'Ошибка';
      });
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/favorites/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final favs = data.map<Map<String, dynamic>>((item) {
          return {
            'id': item['id'],
            'title': item['title'],
            'imagePath': item['image'],
            'ingredients': item['ingredients'],
            'steps': item['steps'],
          };
        }).toList();

        setState(() {
          favorites = favs;
          FavoriteRecipes.setAll(favs);
        });
      }
    } catch (e) {
      print('Ошибка при загрузке избранных рецептов: $e');
    }
  }

  Future<void> _removeFavorite(int id, String title) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/favorites/$id'));
      if (response.statusCode == 200) {
        setState(() {
          favorites.removeWhere((item) => item['id'] == id);
          FavoriteRecipes.remove(title);
        });
      }
    } catch (e) {
      print('Ошибка при удалении избранного: $e');
    }
  }

  // 📝 Диалоговое окно для изменения имени
  Future<void> _showEditNameDialog() async {
    final controller = TextEditingController(text: username);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Изменить имя'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Новое имя',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Сохранить'),
              onPressed: () {
                _updateUserName(controller.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // 🛠 Обновление имени пользователя на сервере
  Future<void> _updateUserName(String newName) async {
    if (newName.trim().isEmpty) return;

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': newName}),
      );

      if (response.statusCode == 200) {
        setState(() {
          username = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Имя успешно обновлено')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Ошибка при обновлении имени')),
        );
      }
    } catch (e) {
      print('Ошибка при обновлении имени: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Ошибка соединения')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Мой профиль'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: _showEditNameDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Food lover 🍽',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Избранные рецепты',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green[800],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (favorites.isEmpty)
              const Text('Пока нет избранных рецептов 🙃'),
            ...favorites.map((recipe) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[100],
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      recipe['imagePath'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(recipe['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _removeFavorite(recipe['id'], recipe['title']),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeScreen(
                          title: recipe['title'],
                          imagePath: recipe['imagePath'],
                          ingredients: List<String>.from(recipe['ingredients']),
                          steps: List<String>.from(recipe['steps']),
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
