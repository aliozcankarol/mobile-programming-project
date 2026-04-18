import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _userService = UserService();
  final _currentUser = FirebaseAuth.instance.currentUser;
  
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }
  
  void _loadCurrentData() {
    if (_currentUser == null) return;
    
    // Auth verileri
    _nameController.text = _currentUser?.displayName ?? '';
    _emailController.text = _currentUser?.email ?? '';
    _usernameController.text = '@${_currentUser?.email?.split('@')[0] ?? ''}';
    
    // Veritabanı verilerini okumayı future ile veya ilk girişte halledelim
    _userService.getUserProfileStream(_currentUser!.uid).first.then((data) {
      if (data != null && mounted) {
        setState(() {
          if (data['name'] != null) _nameController.text = data['name'];
          if (data['username'] != null) _usernameController.text = data['username'];
          if (data['phone'] != null) _phoneController.text = data['phone'];
          if (data['bio'] != null) _bioController.text = data['bio'];
        });
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_currentUser == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      await _userService.updateUserProfile(
        _currentUser!.uid,
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
      );
      
      // FirebaseAuth ismini de güncelleyelim
      await _currentUser!.updateDisplayName(_nameController.text.trim());
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil başarıyla güncellendi!'), backgroundColor: Colors.deepPurple)
        );
        Navigator.pop(context); // Kaydettikten sonra geri döner
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red)
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
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

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
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.amber, strokeWidth: 2))
                : const Text('Kaydet', style: TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profil Fotoğrafı
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
            _buildTextField('Ad Soyad', 'Örn: Ali Yılmaz', Icons.person_outline, _nameController),
            const SizedBox(height: 16),
            _buildTextField('Kullanıcı Adı', '@', Icons.alternate_email, _usernameController),
            const SizedBox(height: 16),
            _buildTextField('E-posta (Değiştirilemez)', 'E-posta', Icons.email_outlined, _emailController, enabled: false),
            const SizedBox(height: 16),
            _buildTextField('Telefon Numarası', '+90 555 123 4567', Icons.phone_outlined, _phoneController),
            const SizedBox(height: 16),
            _buildTextField('Hakkımda', 'Kendinden bahset...', Icons.info_outline, _bioController, maxLines: 3),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder, IconData icon, TextEditingController controller, {int maxLines = 1, bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          enabled: enabled,
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