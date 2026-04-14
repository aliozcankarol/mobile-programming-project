// lib/screens/watchlist_page.dart

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Örnek olarak listedeki ilk 2 filmi favorilere eklenmiş gibi gösteriyoruz
    final watchList = [mockMovies[0], mockMovies[3]]; 

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('İzleme Listem', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
        ),
        itemCount: watchList.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: watchList[index]);
        },
      ),
    );
  }
}