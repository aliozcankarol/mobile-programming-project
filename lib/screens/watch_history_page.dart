import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class WatchHistoryPage extends StatelessWidget {
  const WatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('İzleme Geçmişi'), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
        ),
        itemCount: 1, // Sadece geçmişte izlenen örnek bir film gösteriyoruz
        itemBuilder: (context, index) {
          return MovieCard(movie: mockMovies[1]); // Forrest Gump örneği
        },
      ),
    );
  }
}