import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/user_service.dart';
import '../widgets/movie_card.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  final _tmdbService = TmdbService();
  final _userService = UserService();
  final _currentUser = FirebaseAuth.instance.currentUser;
  
  List<Movie> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  // Filtre Değişkenleri
  List<int> _selectedGenres = [];
  double _minRating = 7.5;
  bool _isFilterActive = false;

  // TMDB Tür ID eşleştirmeleri
  final Map<String, int> _genreMap = {
    'Aksiyon': 28,
    'Komedi': 35,
    'Dram': 18,
    'Bilim Kurgu': 878,
    'Korku': 27,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    if (_currentUser == null) return;

    final prefs = await _userService.getFilterPreferences(_currentUser.uid);
    if (prefs != null && mounted) {
      setState(() {
        _selectedGenres = List<int>.from(prefs['genres'] ?? []);
        _minRating = (prefs['minRating'] ?? 7.5).toDouble();
      });
      // Eğer kullanıcının daha önceden kaydettiği bir tercihi varsa direk uygula
      if (_selectedGenres.isNotEmpty || _minRating > 0) {
        _applyFilters();
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
        if (_isFilterActive) _applyFilters(); // Arama silinince filtre varsa ona dön
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isLoading = true;
        _isFilterActive = false; // Metin arması başlayınca filtre bayrağını kapat
      });
      
      try {
        final results = await _tmdbService.searchMovies(query);
        if (mounted) {
          setState(() {
            _searchResults = results;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Arama hatası: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  Future<void> _applyFilters() async {
    if (_currentUser != null) {
      // Tercihleri Firebase'e kaydet
      await _userService.saveFilterPreferences(_currentUser.uid, _selectedGenres, _minRating);
    }

    setState(() {
      _isLoading = true;
      _isFilterActive = true;
      _searchController.clear(); // Arama çubuğunu temizle
    });

    try {
      final results = await _tmdbService.discoverMovies(
        genres: _selectedGenres,
        minRating: _minRating,
      );
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Filtreleme hatası: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        // Alt sayfanın kendi anlık durumunu yönetmek için StatefulBuilder kullanıyoruz
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Filtrele', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedGenres.clear();
                                _minRating = 0.0;
                              });
                            }, 
                            child: const Text('Temizle', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      
                      const Text('Film Türü', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        children: _genreMap.entries.map((entry) {
                          final isSelected = _selectedGenres.contains(entry.value);
                          return FilterChip(
                            label: Text(entry.key),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setModalState(() {
                                if (selected) {
                                  _selectedGenres.add(entry.value);
                                } else {
                                  _selectedGenres.remove(entry.value);
                                }
                              });
                            },
                            selectedColor: Colors.deepPurple.withValues(alpha: 0.2),
                            checkmarkColor: Colors.deepPurple,
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 25),
                      const Text('Minimum Puan (IMDb)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _minRating,
                              min: 0,
                              max: 10,
                              divisions: 20,
                              activeColor: Colors.deepPurple,
                              label: _minRating.toStringAsFixed(1),
                              onChanged: (value) {
                                setModalState(() {
                                  _minRating = value;
                                });
                              },
                            ),
                          ),
                          Text(_minRating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Menüyü kapat
                          _applyFilters(); // API'yi çağır
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Sonuçları Göster', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Keşfet & Ara', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Film, yönetmen veya oyuncu ara...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      // Etkinlik bayrağını takip et
                      suffixIcon: _isFilterActive 
                        ? const Icon(Icons.filter_list, color: Colors.amber) 
                        : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showFilterSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isFilterActive ? Colors.amber : Colors.deepPurple, 
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Icon(Icons.tune, color: _isFilterActive ? Colors.deepPurple : Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Eğer filtre aktifse "Etkin Filtreler" başlığı koyalım
            if (_isFilterActive && _searchResults.isNotEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text("Sana Özel Filtrelenmiş Sonuçlar:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ),
              ),

            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
                : (_searchController.text.isEmpty && !_isFilterActive)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded, size: 80, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          const Text('Bulmak istediğiniz filmi arayın', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('veya sağdaki menüden filtre uygulayın', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    )
                  : _searchResults.isEmpty
                    ? const Center(child: Text('Hiçbir sonuç bulunamadı.'))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          return MovieCard(movie: _searchResults[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}