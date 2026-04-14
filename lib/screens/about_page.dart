// lib/screens/about_page.dart

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hakkında'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_filter, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              const Text('CineVault', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 10),
              const Text('Sürüm 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 40),
              const Text(
                'Bu uygulama, Mobil Programlama dersi kapsamında tasarlanmış bir sinema asistanı ve takip aracıdır.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              const Text('Geliştirici', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              const Text('Ali Özcan Karol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.deepPurple)),
            ],
          ),
        ),
      ),
    );
  }
}