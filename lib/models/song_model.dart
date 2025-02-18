class Song {
  final String title;
  final String artist;
  final String audioUrl;
  final String coverImage;

  Song({required this.title, required this.artist, required this.audioUrl, required this.coverImage});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      artist: json['artist']['name'],
      audioUrl: json['preview'], // 30-second preview (Deezer)
      coverImage: json['album']['cover_medium'],
    );
  }
}
