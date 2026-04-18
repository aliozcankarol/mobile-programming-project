import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Kullanıcı profil verilerini getir (Telefon, Hakkımda vs.)
  Stream<Map<String, dynamic>?> getUserProfileStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }

  // Kullanıcıyı Firestore'da güncelle / yarat
  Future<void> updateUserProfile(String uid, {
    required String name,
    required String email,
    required String username,
    required String phone,
    required String bio,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'username': username,
      'phone': phone,
      'bio': bio,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
  
  // İstatistik için: İzleme listesindeki film sayısı
  Future<int> getWatchlistCount(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).collection('watchlist').get();
    return snapshot.docs.length;
  }

  // --- HISTORY & COMMENTS ---

  // İzleme geçmişine ekle (İzledim işareti veya Yorum kaydı)
  Future<void> markAsWatched(String uid, Movie movie, {String? comment}) async {
    final docRef = _firestore.collection('users').doc(uid).collection('history').doc(movie.id);
    
    // Var olan data'nın yanına comment eklenebilir veya silinmeden merge edilebilir
    final data = movie.toFirestore();
    if (comment != null && comment.isNotEmpty) {
      data['comment'] = comment;
    }
    
    await docRef.set(data, SetOptions(merge: true));
  }

  // İzleme geçmişi stream'i
  Stream<List<Map<String, dynamic>>> getWatchHistoryStream(String uid) {
    return _firestore.collection('users').doc(uid).collection('history')
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Movie model parse edilsin diye
        return data; 
      }).toList();
    });
  }

  // İzlenen Film Sayısı
  Future<int> getHistoryCount(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).collection('history').get();
    return snapshot.docs.length;
  }

  // Yorum Yapılan Film Sayısı
  Future<int> getCommentCount(String uid) async {
    // Sadece "comment" alanı olanları çekmek yerine hepsini çekip istemci tarafında filtreleyebiliriz 
    // ama where ile null olmayanları da sayabiliriz. Şimdilik hızlı çözüm: client side count
    final snapshot = await _firestore.collection('users').doc(uid).collection('history').get();
    int count = 0;
    for (var doc in snapshot.docs) {
      if (doc.data().containsKey('comment')) count++;
    }
    return count;
  }

  // --- PREFERENCES ---

  // Kullanıcı filtre tercihlerini kaydet (Firebase Cloud)
  Future<void> saveFilterPreferences(String uid, List<int> genres, double minRating) async {
    await _firestore.collection('users').doc(uid).set({
      'preferences': {
        'genres': genres,
        'minRating': minRating,
      }
    }, SetOptions(merge: true));
  }

  // Kullanıcının kayıtlı filtre tercihlerini çek
  Future<Map<String, dynamic>?> getFilterPreferences(String uid) async {
    final docRefs = await _firestore.collection('users').doc(uid).get();
    if (docRefs.exists) {
      final data = docRefs.data();
      if (data != null && data.containsKey('preferences')) {
        return data['preferences'] as Map<String, dynamic>;
      }
    }
    return null;
  }
}
