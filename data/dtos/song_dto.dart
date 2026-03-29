import '../../model/songs/song.dart';

class SongDto {
  static const String titleKey = 'title';
  static const String durationKey = 'duration'; // in ms
  static const String artistIdKey = 'artistId';
  static const String imageUrlKey = 'imageUrl';
  static const String likes = "likes";

  static Song fromJson(String id, Map<String, dynamic> json) {
    print('DEBUG json: $json');
    assert(json[titleKey] is String);
    assert(json[durationKey] is int);
    assert(json[artistIdKey] is String);
    assert(json[imageUrlKey] is String);

    return Song(
      id: id,
      title: json[titleKey],
      artistId: json[artistIdKey],
      duration: Duration(milliseconds: json[durationKey]),
      imageUrl: Uri.parse(json[imageUrlKey]),
      likes: json['likes'] ?? 0,
    );
  }

  /// Convert Song to JSON
  Map<String, dynamic> toJson(Song song) {
    return {
      titleKey: song.title,
      artistIdKey: song.artistId,
      durationKey: song.duration.inMilliseconds,
      imageUrlKey: song.imageUrl.toString(),
    };
  }
}
