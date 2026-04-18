import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';
import '../services/watchlist_service.dart';
import '../services/user_service.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  void _showCommentDialog(BuildContext context, String currentUserId) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Yorum Ekle'),
          content: TextField(
            controller: commentController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Film hakkındaki kişisel düşüncelerinizi yazın...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final commentText = commentController.text.trim();
                Navigator.pop(ctx);
                
                if (commentText.isNotEmpty) {
                  try {
                    await UserService().markAsWatched(currentUserId, movie, comment: commentText);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Yorumunuz İzleme Geçmişine kaydedildi!'), backgroundColor: Colors.green),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(movie.posterUrl, width: double.infinity, height: 450, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(movie.rating, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 20),
                      const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(movie.year, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Özet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(movie.synopsis, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
                  const SizedBox(height: 30),
                  
                  // Butonlar Alanı
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                         final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                         if (currentUserId == null) {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen önce giriş yapın.'), backgroundColor: Colors.red));
                           return;
                         }
                         try {
                           await WatchlistService().addToWatchlist(currentUserId, movie);
                           if (context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('İzleme listesine eklendi!'), backgroundColor: Colors.deepPurple));
                           }
                         } catch (e) {
                           if (context.mounted) {
                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e'), backgroundColor: Colors.red));
                           }
                         }
                      },
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('İzleme Listeme Ekle', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  // Alt iki buton: İzledim ve Yorum Ekle
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                            if (currentUserId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen önce giriş yapın.'), backgroundColor: Colors.red));
                              return;
                            }
                            await UserService().markAsWatched(currentUserId, movie);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Geçmişinize eklendi!'), backgroundColor: Colors.green));
                            }
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('İzledim'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.green,
                            side: const BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                            if (currentUserId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen önce giriş yapın.'), backgroundColor: Colors.red));
                              return;
                            }
                            _showCommentDialog(context, currentUserId);
                          },
                          icon: const Icon(Icons.comment),
                          label: const Text('Yorum Yap'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}