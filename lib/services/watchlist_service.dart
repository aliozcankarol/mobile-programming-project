import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection referansını merkezi olarak tutalım
  CollectionReference _watchlistRef(String userId) {
    return _firestore.collection('users').doc(userId).collection('watchlist');
  }

  // İzleme listesine film ekle
  Future<void> addToWatchlist(String userId, Movie movie) async {
    try {
      // Film eklerken ID'si yoksa yeni bir doküman oluştur, varsa o ID ile yaz
      // movie.id'yi document string olarak kullanıyoruz.
      DocumentReference docRef;
      if (movie.id != null && movie.id!.isNotEmpty) {
        docRef = _watchlistRef(userId).doc(movie.id);
      } else {
        docRef = _watchlistRef(userId).doc();
      }

      await docRef.set(movie.toFirestore());
    } catch (e) {
      throw Exception('İzleme listesine eklenirken hata oluştu: $e');
    }
  }

  // İzleme listesinden film sil
  Future<void> removeFromWatchlist(String userId, String movieId) async {
    try {
      await _watchlistRef(userId).doc(movieId).delete();
    } catch (e) {
      throw Exception('Film silinirken hata oluştu: $e');
    }
  }

  // İzleme listesini Stream olarak getir
  Stream<List<Movie>> getWatchlistStream(String userId) {
    return _watchlistRef(userId)
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Movie.fromFirestore(doc)).toList();
    });
  }
}
