import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  
  static const String apiKey = '4abaa90bf5841b02aeaf36d968f4feb5';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    if (apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception('Lütfen lib/services/tmdb_service.dart içine kendi TMDB API Keyinizi ekleyin!');
    }

    final response = await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&language=tr-TR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromTmdb(json)).toList();
    } else {
      throw Exception('Popüler filmler yüklenemedi: ${response.statusCode}');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception('Lütfen TMDB API Keyinizi ekleyin!');
    }
    
    if (query.isEmpty) return [];

    final response = await http.get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&language=tr-TR&query=${Uri.encodeComponent(query)}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromTmdb(json)).toList();
    } else {
      throw Exception('Film arama başarısız oldu.');
    }
  }

  
  Future<List<Movie>> discoverMovies({List<int>? genres, double? minRating}) async {
    if (apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception('Lütfen TMDB API Keyinizi ekleyin!');
    }

    String url = '$baseUrl/discover/movie?api_key=$apiKey&language=tr-TR&sort_by=popularity.desc';
    
    if (genres != null && genres.isNotEmpty) {
      url += '&with_genres=${genres.join(',')}';
    }
    if (minRating != null) {
      url += '&vote_average.gte=$minRating';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Movie.fromTmdb(json)).toList();
    } else {
      throw Exception('Kriterlere uygun filmler getirilemedi.');
    }
  }
}
