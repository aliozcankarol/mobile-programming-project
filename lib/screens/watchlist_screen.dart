import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/watchlist_service.dart';

class WatchlistScreen extends StatelessWidget {
  final String userId;

  const WatchlistScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final WatchlistService watchlistService = WatchlistService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('İzleme Listem'),
      ),
      body: StreamBuilder<List<Movie>>(
        stream: watchlistService.getWatchlistStream(userId),
        builder: (context, snapshot) {
          // Yükleniyor durumu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Hata durumu
          if (snapshot.hasError) {
            return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
          }

          // Veri yok veya liste boş durumu
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Henüz film eklenmedi',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final movies = snapshot.data!;

          // Filmlerin ListView içinde gösterilmesi
          return ListView.builder(
            itemCount: movies.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: ListTile(
                  leading: movie.posterUrl.isNotEmpty 
                    ? Image.network(
                        movie.posterUrl, 
                        width: 50, 
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.movie),
                      )
                    : const Icon(Icons.movie, size: 50),
                  title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Puan: ${movie.rating} • ${movie.year}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Silme fonksiyonu
                      if (movie.id != null) {
                        try {
                          await watchlistService.removeFromWatchlist(userId, movie.id!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Film listeden silindi.')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Silinirken hata: $e')),
                            );
                          }
                        }
                      }
                    },
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
