import 'package:flutter/material.dart';
import 'recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> dummyData = [
    {
      'author': 'Raymond',
      'time': '2 hrs ago',
      'image': 'assets/images/food4.png',
      'likes': 300,
      'liked': false,
      'comments': '100',
      'saves': '50',
      'title': 'Char Noodle Soup',
      'ingredients': [
        '300g egg noodles',
        '300g char siu (barbecue pork), thinly sliced',
        '1.5 L chicken or pork broth',
        '2 cloves garlic, minced',
        '1 tsp ginger, minced',
        '100g bok choy or pak choi',
        '2 tbsp soy sauce',
        '1 tbsp oyster sauce',
        '2 spring onions, sliced',
        'sesame oil, to taste',
        'salt and pepper'
      ],
      'steps': [
        'В маленькой кастрюле разогрейте бульон. Добавьте чеснок и имбирь, доведите до лёгкого кипения.',
        'Отдельно отварите лапшу согласно инструкции на упаковке, слейте и разделите по мискам.',
        'В горячий бульон добавьте соевый и устричный соус, приправьте по вкусу.',
        'Добавьте в бульон листья бок choy и готовьте 1-2 минуты, пока овощи не станут мягкими.',
        'Выложите в миску лапшу, сверху положите ломтики char siu, залейте горячим бульоном с овощами.',
        'Украсьте зелёным луком, добавьте каплю кунжутного масла и подавайте горячим.'
      ],
    },
    {
      'author': 'Li Hua',
      'time': '3 hrs ago',
      'image': 'assets/images/food5.png',
      'likes': 1800,
      'liked': false,
      'comments': '540',
      'saves': '320',
      'title': 'Хого — китайский хот-пот (火锅)',
      'ingredients': [
        'Двойной бульон: острый (чили, сычуаньский перец) и неострый (костный или грибной)',
        'Тонко нарезанная говядина или баранина',
        'Овощи (капуста, шпинат, зелень)',
        'Грибы (вешенки, шиитаке)',
        'Лапша (рисовая или пшеничная)',
        'Морепродукты (креветки, кальмары)',
        'Соусы для обмакивания (кунжутный, соевый, острый)',
      ],
      'steps': [
        'Подготовьте две части бульона: острый с перцем чили и сычуаньским перцем, неострый — на костном или грибном отваре.',
        'Поставьте кастрюлю с двойным бульоном на плиту по центру стола.',
        'Разложите ингредиенты (мясо, овощи, грибы, лапшу и морепродукты) вокруг кастрюли.',
        'Каждый гость опускает выбранные ингредиенты в бульон и варит их прямо за столом.',
        'Готовые кусочки макают в соусы по вкусу и наслаждаются горячим блюдом.',
      ],
    },
    {
      'author': 'Sakura',
      'time': '5 hrs ago',
      'image': 'assets/images/food6.png',
      'likes': 980,
      'liked': false,
      'comments': '210',
      'saves': '170',
      'title': 'Боулы — овощные поке и Buddha bowls 🥗',
      'ingredients': [
        'Рис или киноа (в основе)',
        'Авокадо, морковь, огурцы',
        'Капуста, шпинат, зелень',
        'Кукуруза, фасоль, тофу',
        'Соусы (соевый, кунжутный, арахисовый)',
      ],
      'steps': [
        'Отварите основу — рис или киноа, остудите.',
        'Подготовьте овощи: нарежьте авокадо, морковь, огурцы, капусту.',
        'Разложите ингредиенты слоями или секторами в миске.',
        'Добавьте белковую часть — тофу или фасоль.',
        'Полейте соусом по вкусу и украсьте зеленью.',
      ],
    },
    {
      'author': 'Marco',
      'time': '7 hrs ago',
      'image': 'assets/images/food7.png',
      'likes': 2310,
      'liked': false,
      'comments': '860',
      'saves': '540',
      'title': 'Пицца со шпинатом и моцареллой 🍕',
      'ingredients': [
        'Тонкое итальянское тесто',
        'Моцарелла (шарики)',
        'Свежий шпинат или базилик',
        'Оливковое масло и немного сыра',
        'Бальзамик (по желанию)',
      ],
      'steps': [
        'Раскатайте тесто в тонкий круг.',
        'Смажьте поверхность оливковым маслом, добавьте шпинат и моцареллу.',
        'Посыпьте сыром и при желании сбрызните бальзамиком.',
        'Выпекайте в духовке при 220 °C около 10 минут, пока корочка не станет золотистой.',
        'Подавайте горячей с бокалом белого вина или соком.',
      ],
    },
    {
      'author': 'Anna',
      'time': '9 hrs ago',
      'image': 'assets/images/food8.png',
      'likes': 3200,
      'liked': false,
      'comments': '1250',
      'saves': '800',
      'title': 'Шоколадный брауни в рождественском стиле 🎄',
      'ingredients': [
        'Шоколадный брауни или кекс',
        'Сахарная пудра (для украшения)',
        'Еловая веточка и красные ягоды',
        'Какао или шоколад для теста',
        'Яйца, мука, сахар, сливочное масло',
      ],
      'steps': [
        'Приготовьте тесто для брауни, выпекайте при 180 °C около 25 минут.',
        'Остудите и аккуратно разрежьте на кусочки.',
        'Посыпьте сахарной пудрой для эффекта снега.',
        'Украсьте веточкой ели и ягодами.',
        'Подавайте как праздничный десерт к чаю или какао.',
      ],
    },
  ];

  void toggleLike(int index) {
    setState(() {
      dummyData[index]['liked'] = !dummyData[index]['liked'];
      if (dummyData[index]['liked']) {
        dummyData[index]['likes']++;
      } else {
        dummyData[index]['likes']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '🍽 Рекомендации',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final item = dummyData[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeScreen(
                    title: item['title'] as String,
                    imagePath: item['image'] as String,
                    ingredients: List<String>.from(item['ingredients'] as List),
                    steps: List<String>.from(item['steps'] as List),
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                      ),
                    ),
                    title: Text(item['author'] as String),
                    subtitle: Text(item['time'] as String),
                    trailing: const Icon(Icons.more_vert),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      item['image'] as String,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ❤️ Лайк
                        GestureDetector(
                          onTap: () => toggleLike(index),
                          child: Row(
                            children: [
                              Icon(
                                item['liked']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    item['liked'] ? Colors.red : Colors.black54,
                                size: 22,
                              ),
                              const SizedBox(width: 6),
                              Text(item['likes'].toString()),
                            ],
                          ),
                        ),
                        // 💬 Комментарии
                        Row(
                          children: [
                            const Icon(Icons.chat_bubble_outline, size: 22),
                            const SizedBox(width: 6),
                            Text(item['comments'] as String),
                          ],
                        ),
                        // 🔖 Сохранения
                        Row(
                          children: [
                            const Icon(Icons.bookmark_border, size: 22),
                            const SizedBox(width: 6),
                            Text(item['saves'] as String),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
