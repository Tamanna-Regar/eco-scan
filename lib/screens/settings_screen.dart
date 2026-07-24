import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          // Profile
          ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: const Text("Profile"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
          const Divider(),

          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: const Text("Notifications"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showSnackBar("Notifications clicked!"),
          ),

          // Language
          ListTile(
            leading: const Icon(Icons.language, color: Colors.green),
            title: const Text("Language"),
            subtitle: Text(selectedLanguage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(),
          ),

          // Dark Mode
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.green),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: themeNotifier.value == ThemeMode.dark,
              activeThumbColor: Colors.green,
              activeTrackColor: Colors.green.withAlpha(128),
              onChanged: (bool value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                setState(() {});
              },
            ),
          ),
          const Divider(),

          // About App
          ListTile(
            leading: const Icon(Icons.info, color: Colors.green),
            title: const Text("About App"),
            onTap: () =>
                showAboutDialog(context: context, applicationName: "Eco-Scan"),
          ),

          // Logout
          // Dark Mode
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.green),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: themeNotifier.value == ThemeMode.dark,

              // --- Yahan update karo ---
              activeThumbColor: Colors.green,
              activeTrackColor: Colors.green.withAlpha(128),
              // -------------------------

              onChanged: (bool value) {
                themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                setState(() {});
              },
            ),
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: ['English', 'Hindi', 'Marathi', 'Gujarati']
            .map((lang) => SimpleDialogOption(
                  child: Text(lang),
                  onPressed: () {
                    setState(() {
                      selectedLanguage = lang;
                    });
                    Navigator.pop(context);
                    _showSnackBar("Language: $lang");
                  },
                ))
            .toList(),
      ),
    );
  }
}
