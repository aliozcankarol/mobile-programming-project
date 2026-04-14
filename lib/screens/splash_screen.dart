// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'dart:async'; // Zamanlayıcı (Timer) kullanmak için gerekli
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Uygulama açıldıktan sonra 2 saniye bekler ve AuthScreen'e (Giriş) yönlendirir
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dev boyutta logo ikonumuz
            Icon(Icons.movie_filter, size: 120, color: Colors.white),
            SizedBox(height: 24),
            // Uygulama adı
            Text(
              'CineVault',
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                letterSpacing: 2, // Harflerin arasını biraz açarak daha estetik yaptık
              ),
            ),
            SizedBox(height: 50),
            // Şık bir yükleme animasyonu (Sarı renkli)
            CircularProgressIndicator(
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}