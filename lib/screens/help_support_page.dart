import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Yardım ve Destek'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text('Şifremi nasıl sıfırlarım?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [Padding(padding: EdgeInsets.all(16.0), child: Text('Giriş ekranındaki "Şifremi Unuttum" bağlantısına tıklayarak e-posta adresinize sıfırlama linki gönderebilirsiniz.'))]
          ),
          ExpansionTile(
            title: Text('İzleme listesi nasıl çalışır?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: [Padding(padding: EdgeInsets.all(16.0), child: Text('Filmlerin detay sayfasındaki "Listeme Ekle" butonuna basarak favorilerinizi kaydedebilirsiniz.'))]
          ),
        ],
      ),
    );
  }
}