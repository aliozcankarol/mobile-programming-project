// lib/screens/edit_profile_page.dart

import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profili Düzenle', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Sağ üstteki Kaydet butonu
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil başarıyla güncellendi!'), backgroundColor: Colors.deepPurple)
              );
              Navigator.pop(context); // Kaydettikten sonra geri döner
            },
            child: const Text('Kaydet', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profil Fotoğrafı ve Kamera İkonu (Gerçekçi Tasarım)
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.deepPurple, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Form Alanları
            _buildTextField('Ad Soyad', 'Ali Özcan Karol', Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField('Kullanıcı Adı', '@alikarol', Icons.alternate_email),
            const SizedBox(height: 16),
            _buildTextField('E-posta', 'alikarol@example.com', Icons.email_outlined),
            const SizedBox(height: 16),
            _buildTextField('Telefon Numarası', '+90 555 123 45 67', Icons.phone_outlined),
            const SizedBox(height: 16),
            _buildTextField('Hakkımda', 'Sinema tutkunu, yazılım geliştirici ve gezgin.', Icons.info_outline, maxLines: 3),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Tekrar eden metin kutularını çizmek için özel bir fonksiyon
  Widget _buildTextField(String label, String placeholder, IconData icon, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: maxLines == 1 ? Icon(icon, color: Colors.grey) : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}