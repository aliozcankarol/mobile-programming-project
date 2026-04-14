

class Movie {
  final String title;
  final String posterUrl;
  final String rating;
  final String year;
  final String synopsis;
  
  const Movie({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.year,
    required this.synopsis,
  });
}


final List<Movie> mockMovies = [
  const Movie(
    title: 'The Dark Knight',
    posterUrl: 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
    rating: '9.0/10', year: '2008', synopsis: 'Batman, Gotham sokaklarında yeni bir tehdit olan Joker ile karşı karşıyadır.',
  ),
  const Movie(
    title: 'Forrest Gump',
    posterUrl: 'https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
    rating: '8.8/10', year: '1994', synopsis: 'Düşük IQ\'lu ama altın kalpli bir adamın olağanüstü hayat hikayesi.',
  ),
  const Movie(
    title: 'Inception',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_FMjpg_UX1000_.jpg',
    rating: '8.8/10', year: '2010', synopsis: 'Rüyalara girerek fikir çalan bir hırsızın son ve en tehlikeli görevi.',
  ),
  const Movie(
    title: 'The Shawshank Redemption',
    posterUrl: 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg',
    rating: '9.3/10', year: '1994', synopsis: 'Masumiyetini iddia etmesine rağmen hapse giren bir adamın umut dolu hikayesi.',
  ),
];