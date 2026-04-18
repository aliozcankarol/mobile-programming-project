import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String? id;
  final String title;
  final String posterUrl;
  final String rating;
  final String year;
  final String synopsis;
  final DateTime? addedDate;
  
  const Movie({
    this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.synopsis,
    this.addedDate,
  });

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return Movie(
      id: doc.id,
      title: data?['title'] ?? '',
      posterUrl: data?['posterUrl'] ?? '',
      rating: data?['rating'] ?? '',
      year: data?['year'] ?? '',
      synopsis: data?['synopsis'] ?? '',
      addedDate: data?['addedDate'] != null ? (data!['addedDate'] as Timestamp).toDate() : null,
    );
  }

  factory Movie.fromTmdb(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] ?? '';
    final fullPosterUrl = posterPath.isNotEmpty 
        ? 'https://image.tmdb.org/t/p/w500$posterPath' 
        : 'https://via.placeholder.com/500x750.png?text=No+Poster'; // fallback image
        
    final releaseDate = json['release_date'] ?? '';
    final yearStr = releaseDate.isNotEmpty && releaseDate.length >= 4 
        ? releaseDate.substring(0, 4) 
        : 'N/A';

    return Movie(
      id: json['id'].toString(),
      title: json['title'] ?? 'Unknown',
      posterUrl: fullPosterUrl,
      rating: '${(json['vote_average'] ?? 0.0).toStringAsFixed(1)}/10',
      year: yearStr,
      synopsis: json['overview'] ?? 'No synopsis available.',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      // id, Document ID olarak Firestore'da tutulduğu için map'e eklemiyoruz
      'title': title,
      'posterUrl': posterUrl,
      'rating': rating,
      'year': year,
      'synopsis': synopsis,
      'addedDate': addedDate != null ? Timestamp.fromDate(addedDate!) : FieldValue.serverTimestamp(),
    };
  }
}