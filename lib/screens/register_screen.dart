// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'main_navigation.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _register() async {
    if (_emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _passwordConfirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen gerekli alanları doldurun.')),
      );
      return;
    }

    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şifreler uyuşmuyor.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      // İsteğe bağlı olarak kullanıcının display name'ini güncelleyebiliriz
      if (_nameController.text.isNotEmpty) {
        await _authService.currentUser?.updateDisplayName(_nameController.text.trim());
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => const MainNavigation()), 
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Ad Soyad', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.person_outline, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 16),
              
              // E-posta
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'E-posta Adresi', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.email_outlined, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 16),
              
              // Şifre
              TextField(
                controller: _passwordController,
                obscureText: true, 
                decoration: InputDecoration(hintText: 'Şifre', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.lock_outline, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 16),

              // Şifre Tekrar
              TextField(
                controller: _passwordConfirmController,
                obscureText: true, 
                decoration: InputDecoration(hintText: 'Şifre (Tekrar)', filled: true, fillColor: Colors.white, prefixIcon: const Icon(Icons.lock_reset, color: Colors.deepPurple), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))
              ),
              const SizedBox(height: 30),
              
              // Kayıt Ol Butonu
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.deepPurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.deepPurple)
                      : const Text('Kayıt Ol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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