import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Song> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce; // ✅ Debounce timer to avoid multiple API calls

  @override
  void initState() {
    super.initState();

    // ✅ Listen for text changes and auto-search
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (_searchController.text.isNotEmpty) {
          _performSearch();
        } else {
          setState(() {
            _searchResults = [];
          });
        }
      });
    });
  }

  // 🔍 Perform search API call
  void _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Song> results = await ApiService.searchSongs(_searchController.text);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error searching: $e");
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Search Songs")),
      body: Column(
        children: [
          // 🔍 Search Bar (Auto-search as you type)
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search songs...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // 🔄 Loading Indicator
          if (_isLoading) const CircularProgressIndicator(),

          // 🎶 Show Search Results
          Expanded(
            child: _searchResults.isEmpty
                ? const Center(child: Text("Start typing to search..."))
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final song = _searchResults[index];
                      return ListTile(
                        leading: Image.network(song.coverImage, width: 50, height: 50),
                        title: Text(song.title),
                        subtitle: Text(song.artist),
                        onTap: () {
                          // ✅ Set playlist to search results before playing
                          audioProvider.setPlaylist(_searchResults);
                          audioProvider.playSong(index);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
