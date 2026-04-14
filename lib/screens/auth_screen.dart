// lib/screens/auth_screen.dart

import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'register_screen.dart'; // Kayıt sayfasını bağladık
import 'forgot_password_screen.dart'; // Şifremi unuttum sayfasını bağladık

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_filter, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text('CineVault', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              const Text('Sinema dünyasına hoş geldin', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 50),
              
              TextField(decoration: InputDecoration(hintText: 'E-posta Adresi', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.email, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              TextField(obscureText: true, decoration: InputDecoration(hintText: 'Şifre', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              
              // Şifremi Unuttum Butonu (YENİ)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                  },
                  child: const Text('Şifremi Unuttum?', style: TextStyle(color: Colors.amber)),
                ),
              ),
              
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation())),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Giriş Yap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Çalışan Kayıt Ol Butonu
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: const Text('Hesabın yok mu? Kayıt Ol', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}