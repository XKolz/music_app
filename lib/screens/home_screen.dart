import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/song_model.dart';
import '../providers/audio_provider.dart';
import '../widgets/bottom_player.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Music App")),
      body: FutureBuilder(
        future: ApiService.fetchSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading songs"));
          }

          final songs = snapshot.data as List<Song>;
          audioProvider.setPlaylist(songs);

          return ListView.builder(
            // Add padding at bottom to prevent list items from being hidden behind player
            padding: const EdgeInsets.only(bottom: 90),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(songs[index].coverImage, width: 50, height: 50),
                title: Text(songs[index].title),
                subtitle: Text(songs[index].artist),
                onTap: () => audioProvider.playSong(index),
              );
            },
          );
        },
      ),
      // Use persistent bottom sheet instead of bottomNavigationBar
      bottomSheet: BottomPlayer(),
    );
  }
}