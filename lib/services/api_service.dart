import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/song_model.dart';

class ApiService {
  static Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse('https://api.deezer.com/chart'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['tracks']['data'] as List)
          .map((song) => Song.fromJson(song))
          .toList();
    } else {
      throw Exception("Failed to load songs");
    }
  }

  // 🔍 Search for Songs
  static Future<List<Song>> searchSongs(String query) async {
    final response = await http.get(Uri.parse('https://api.deezer.com/search?q=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((song) => Song.fromJson(song))
          .toList();
    } else {
      throw Exception("Failed to search songs");
    }
  }
}
