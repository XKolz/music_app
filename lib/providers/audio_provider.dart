import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = 0;

  // ✅ Add a getter for playlist
  List<Song> get playlist => _playlist;  

  void setPlaylist(List<Song> songs) {
    _playlist = songs;
    notifyListeners();
  }

  void playSong(int index) async {
    _currentIndex = index;
    await _audioPlayer.setUrl(_playlist[index].audioUrl);
    _audioPlayer.play();
    notifyListeners();
  }

  void pause() {
    _audioPlayer.pause();
    notifyListeners();
  }

  void next() {
    if (_currentIndex < _playlist.length - 1) {
      playSong(_currentIndex + 1);
    }
  }

  void previous() {
    if (_currentIndex > 0) {
      playSong(_currentIndex - 1);
    }
  }

  bool get isPlaying => _audioPlayer.playing;
  int get currentIndex => _currentIndex;
  Song get currentSong => _playlist[_currentIndex];
}
