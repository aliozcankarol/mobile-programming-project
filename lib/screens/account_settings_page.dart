import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Hesap Ayarları'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(leading: Icon(Icons.email, color: Colors.deepPurple), title: Text('E-posta'), subtitle: Text('alikarol@example.com'), trailing: Icon(Icons.edit, size: 20)),
          const Divider(),
          const ListTile(leading: Icon(Icons.lock, color: Colors.deepPurple), title: Text('Şifre Değiştir'), trailing: Icon(Icons.arrow_forward_ios, size: 16)),
          const Divider(),
          const ListTile(leading: Icon(Icons.notifications, color: Colors.deepPurple), title: Text('Bildirim Tercihleri'), trailing: Icon(Icons.arrow_forward_ios, size: 16)),
        ],
      ),
    );
  }
}