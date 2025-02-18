import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class BottomPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        if (audioProvider.playlist.isEmpty) return SizedBox.shrink(); // No songs

        final song = audioProvider.currentSong;

        return BottomAppBar(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SizedBox(
              height: 90, // ✅ Prevents overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Display Song Title & Artist
                  Row(
                    children: [
                      // Album Art
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.coverImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Song Title & Artist
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              song.artist,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // 🔹 Play Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(icon: const Icon(Icons.skip_previous), onPressed: audioProvider.previous),
                      IconButton(
                        icon: Icon(audioProvider.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, size: 35),
                        onPressed: () => audioProvider.isPlaying ? audioProvider.pause() : audioProvider.playSong(audioProvider.currentIndex),
                      ),
                      IconButton(icon: const Icon(Icons.skip_next), onPressed: audioProvider.next),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
