import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';
import '../services/user_service.dart';
import 'movie_detail_page.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Yorumlarım', style: TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.indigo, 
        foregroundColor: Colors.white
      ),
      body: currentUserId == null
        ? const Center(child: Text('Lütfen önce giriş yapın.'))
        : StreamBuilder<List<Map<String, dynamic>>>(
            stream: UserService().getWatchHistoryStream(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.indigo));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Henüz hiçbir filme yorum yapmadınız.', style: TextStyle(fontSize: 16, color: Colors.grey))
                );
              }

              // Sadece yorumu olanları filtrele
              final commentedDocs = snapshot.data!.where((data) => 
                  data.containsKey('comment') && 
                  data['comment'] != null && 
                  data['comment'].toString().trim().isNotEmpty
              ).toList();

              if (commentedDocs.isEmpty) {
                return const Center(
                  child: Text('Henüz hiçbir filme yorum yapmadınız.', style: TextStyle(fontSize: 16, color: Colors.grey))
                );
              }

              return ListView.builder(
                itemCount: commentedDocs.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final data = commentedDocs[index];
                  final parsedMovie = Movie(
                    id: data['id'],
                    title: data['title'] ?? '',
                    posterUrl: data['posterUrl'] ?? '',
                    rating: data['rating'] ?? '',
                    year: data['year'] ?? '',
                    synopsis: data['synopsis'] ?? '',
                  );

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => MovieDetailPage(movie: parsedMovie))
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Film Başlığı ve Ufak Kapak
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    parsedMovie.posterUrl, 
                                    width: 45, height: 65, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 45),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(parsedMovie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
                                      const SizedBox(height: 4),
                                      Text('${parsedMovie.year} yılına ait film', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
                              ],
                            ),
                            
                            const Divider(height: 24),
                            
                            // Yorum Alanı
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.format_quote, size: 28, color: Colors.amber.shade400),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    data['comment'],
                                    style: const TextStyle(
                                      fontSize: 16, 
                                      height: 1.5, 
                                      letterSpacing: 0.2, 
                                      color: Colors.black87
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}
