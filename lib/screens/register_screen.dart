// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'main_navigation.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white, // Geri tuşu rengi
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add_alt_1, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text('Hesap Oluştur', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text('CineVault dünyasına katılın', style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 40),
              
              // Ad Soyad
              TextField(decoration: InputDecoration(hintText: 'Ad Soyad', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.person_outline, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              
              // E-posta
              TextField(decoration: InputDecoration(hintText: 'E-posta Adresi', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.email_outlined, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 16),
              
              // Şifre
              TextField(obscureText: true, decoration: InputDecoration(hintText: 'Şifre', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 16),

              // Şifre Tekrar
              TextField(obscureText: true, decoration: InputDecoration(hintText: 'Şifre (Tekrar)', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.lock_reset, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
              const SizedBox(height: 30),
              
              // Kayıt Ol Butonu
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Kayıt başarılı sayıp ana menüye atıyoruz
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainNavigation()), (route) => false);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Kayıt Ol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}