import 'package:flutter/material.dart';
import 'package:pos_portal/routes/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _init();
  }

  void _init() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushNamed(context, RoutesName.home);
      final isFirst = sharedPreferences.getBool('isFirst') ?? true;
      debugPrint('isFirst: $isFirst');
      if (isFirst) {
        sharedPreferences.setBool('isFirst', false);
        Navigator.pushNamed(context, RoutesName.onboarding);
      } else {
        Navigator.pushNamed(context, RoutesName.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/splash_screen_logo2.png'),
      ),
    );
  }
}
