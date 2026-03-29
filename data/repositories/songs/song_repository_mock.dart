// song_repository_mock.dart

import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [];

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs;
    });
  }

  @override
  Future<void> likeSong(String id) async {
    return Future.delayed(Duration(seconds: 1), () {
      return null;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<List<Comment>> fetchComments(String songId) async {
    return Future.delayed(Duration(seconds: 1), () => []);
  }

  @override
  Future<void> postComment(String songId, String username, String comment) async {
    return Future.delayed(Duration(seconds: 1), () {});
  }
}
