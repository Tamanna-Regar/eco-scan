import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Timer ke liye
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

// Ye global notifier puri app mein theme change handle karega
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(EcoScanApp(isLoggedIn: isLoggedIn));
}

class EcoScanApp extends StatelessWidget {
  final bool isLoggedIn;
  const EcoScanApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Eco-Scan',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          // Yahan humne SplashScreen ko entry point banaya hai
          home: SplashScreen(isLoggedIn: isLoggedIn),
        );
      },
    );
  }
}

// Yahan tumhari SplashScreen hai
class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3 seconds baad redirect karega
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => widget.isLoggedIn
                ? const MainDashboard()
                : const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Yahan 'const' lagao
      backgroundColor: Colors.green,
      body: Center(
        // Yahan 'const' lagao
        child: Column(
          // Yahan 'const' lagao
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.recycling, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text("Eco-Scan",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
