import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';
import 'auth_screen.dart';
import 'account_settings_page.dart';
import 'help_support_page.dart';
import 'about_page.dart';
import 'edit_profile_page.dart';
import 'watch_history_page.dart';
import 'comments_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();
  final _currentUser = FirebaseAuth.instance.currentUser;

  Future<Map<String, int>>? _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    if (_currentUser != null) {
      _statsFuture = Future.wait([
        _userService.getHistoryCount(_currentUser!.uid),
        _userService.getCommentCount(_currentUser!.uid),
      ]).then((results) => {
        'history': results[0],
        'comments': results[1],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Center(child: Text('Lütfen giriş yapın.'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profilim', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Üst Kısım: Profil Fotoğrafı ve Bilgiler
            StreamBuilder<Map<String, dynamic>?>(
              stream: _userService.getUserProfileStream(_currentUser!.uid),
              builder: (context, snapshot) {
                final data = snapshot.data ?? {};
                final name = data['name'] ?? _currentUser!.displayName ?? 'İsimsiz Kullanıcı';
                final username = data['username'] ?? '@${_currentUser!.email?.split('@')[0] ?? 'kullanici'}';
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, size: 45, color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              username,
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage())).then((_) {
                                  // Stats update force
                                  setState(() { _loadStats(); });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 36),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Profili Düzenle'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            ),

            const SizedBox(height: 30),

            // İstatistik Paneli
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: FutureBuilder<Map<String, int>>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  final stats = snapshot.data ?? {'history': 0, 'comments': 0};
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(stats['history'].toString(), 'İzlenen'), 
                      _buildStatItem(stats['comments'].toString(), 'Yorum'),
                    ],
                  );
                }
              ),
            ),

            const SizedBox(height: 30),

            // Menü Başlığı
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Hesap İşlemleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 10),

            // Menü Listesi
            _buildMenuItem(
              context, 
              icon: Icons.history, 
              title: 'İzleme Geçmişi', 
              color: Colors.blue,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WatchHistoryPage())),
            ),
            _buildMenuItem(
              context, 
              icon: Icons.comment_bank_outlined, 
              title: 'Yorumlarım', 
              color: Colors.indigo,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CommentsPage())),
            ),
            _buildMenuItem(
              context, 
              icon: Icons.help_outline_rounded, 
              title: 'Yardım ve Destek', 
              color: Colors.orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportPage())),
            ),
            _buildMenuItem(
              context, 
              icon: Icons.info_outline_rounded, 
              title: 'Hakkında', 
              color: Colors.green,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
            ),

            const Divider(height: 40, indent: 25, endIndent: 25),

            // Çıkış Butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () => _showLogoutDialog(context),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text('Oturumu Kapat', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // İstatistik Yardımcı Widget
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }

  // Menü Öğesi Yardımcı Widget
  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  // Çıkış Onay Diyaloğu
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Çıkış Yap'),
        content: const Text('Oturumunuz kapatılacaktır. Devam etmek istiyor musunuz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Vazgeç')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // popup kapat
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthScreen()), (route) => false);
              }
            },
            child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}