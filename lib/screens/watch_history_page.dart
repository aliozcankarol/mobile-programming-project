import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';
import '../services/user_service.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('İzleme Geçmişi'), 
        backgroundColor: Colors.deepPurple, 
        foregroundColor: Colors.white
      ),
      body: currentUserId == null
        ? const Center(child: Text('Lütfen önce giriş yapın.'))
        : StreamBuilder<List<Map<String, dynamic>>>(
            stream: UserService().getWatchHistoryStream(currentUserId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Henüz izleme geçmişiniz bulunmuyor.', style: TextStyle(fontSize: 16, color: Colors.grey)));
              }

              final historyDocs = snapshot.data!;

              return ListView.builder(
                itemCount: historyDocs.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final data = historyDocs[index];
                  final movie = Movie.fromTmdb(data); // Re-parsing back to Movie context safely
                  // We also override manual fields since we stored them directly.
                  // Since we stored via toFirestore(), we could use fromFirestore but we don't have DocumentSnapshot.
                  // Let's create a Movie object properly.
                  final parsedMovie = Movie(
                    id: data['id'],
                    title: data['title'] ?? '',
                    posterUrl: data['posterUrl'] ?? '',
                    rating: data['rating'] ?? '',
                    year: data['year'] ?? '',
                    synopsis: data['synopsis'] ?? '',
                  );

                  final hasComment = data.containsKey('comment') && data['comment'] != null && data['comment'].toString().isNotEmpty;

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  parsedMovie.posterUrl, 
                                  width: 60, height: 90, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 60),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(parsedMovie.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('${parsedMovie.year} • Puan: ${parsedMovie.rating}', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                    const SizedBox(height: 8),
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                                        SizedBox(width: 4),
                                        Text('İzlendi', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (hasComment) ...[
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade100)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.format_quote, size: 16, color: Colors.blue.shade400),
                                      const SizedBox(width: 6),
                                      Text('Kişisel Notun', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue.shade700)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    data['comment'], 
                                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)
                                  ),
                                ],
                              ),
                            )
                          ]
                        ],
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