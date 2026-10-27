import 'package:flutter/material.dart';

class RecipeScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final List<String> ingredients;
  final List<String> steps;

  const RecipeScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.ingredients,
    required this.steps,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isFavorite = false;
  final TextEditingController _commentController = TextEditingController();
  final List<String> comments = [
    'Отличный рецепт! 👏',
    'Попробовала — очень вкусно 😋',
    'Добавил немного чеснока, получилось супер!',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        comments.add(text);
        _commentController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('💬 Комментарий добавлен!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = widget.imagePath.startsWith('http');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() => isFavorite = !isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite
                      ? '✅ Добавлено в избранное'
                      : '❌ Удалено из избранного'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото рецепта
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isNetworkImage
                  ? Image.network(
                      widget.imagePath,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('assets/images/placeholder.jpg',
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover),
                    )
                  : Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),
            const Text(
              '🧂 Ингредиенты',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.ingredients.map((ing) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text('• $ing'),
                )),

            const SizedBox(height: 16),
            const Text(
              '👨‍🍳 Как готовить',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.steps.asMap().entries.map((entry) {
              final idx = entry.key + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('$idx. ${entry.value}'),
              );
            }),

            const SizedBox(height: 24),
            const Divider(),
            const Text(
              '💬 Комментарии',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Комментарии
            ...comments.reversed.map(
              (c) => ListTile(
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                ),
                title: Text(c),
              ),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Написать комментарий...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: _addComment,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
