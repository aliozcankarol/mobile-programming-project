import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign In with Email & Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Şifre yanlış.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Geçersiz e-posta formatı.');
      }
      throw Exception(e.message ?? 'Giriş sırasında bir hata oluştu.');
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }

  // Register with Email & Password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Şifre çok zayıf.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Bu e-posta adresi zaten kullanımda.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Geçersiz e-posta formatı.');
      }
      throw Exception(e.message ?? 'Kayıt sırasında bir hata oluştu.');
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: $e');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
