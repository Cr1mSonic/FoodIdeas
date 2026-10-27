import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/login_screen.dart';
import 'profile_screen.dart';
import '../screens/about_app_screen.dart';


class SettingsScreen extends StatefulWidget {
  final String? name;
  final String? email;

  const SettingsScreen({
    super.key,
    this.name,
    this.email,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Загружаем имя и email из SharedPreferences или из переданных данных
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      name = widget.name ?? prefs.getString('name') ?? 'Без имени';
      email = widget.email ?? prefs.getString('email') ?? 'Не указан';
    });

    // 📌 Если данные пришли после регистрации — сохраним их
    if (widget.name != null && widget.email != null) {
      await prefs.setString('name', widget.name!);
      await prefs.setString('email', widget.email!);
    }
  }

  /// Очистка локальных данных и переход на экран входа
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text('Настройки', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 Блок профиля с аватаркой
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🔸 Заголовок "Другие настройки"
            const Text(
              'Другие настройки',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),

            // 🔔 Уведомления
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Уведомления'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),

            // ℹ️ О приложении
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('О приложении'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutAppScreen(),
                  ),
                );
              },
            ),

            // 🚪 Выход
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Выйти',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
