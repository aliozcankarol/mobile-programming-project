// lib/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_reset, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text('Şifremi Unuttum', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              const Text(
                'Hesabınıza kayıtlı e-posta adresini girin. Size şifre sıfırlama bağlantısı göndereceğiz.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 40),
              
              TextField(
                decoration: InputDecoration(hintText: 'E-posta Adresi', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.email, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sıfırlama bağlantısı gönderildi!'), backgroundColor: Colors.amber));
                    Navigator.pop(context); // Geldiği sayfaya (Login'e) geri döndürür
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Sıfırlama Linki Gönder', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}