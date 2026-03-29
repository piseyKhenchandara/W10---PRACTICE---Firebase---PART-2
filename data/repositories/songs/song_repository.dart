import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs({bool forceFetch = false});

  Future<Song?> fetchSongById(String id);

  Future<void> likeSong(String id);

  Future<List<Comment>> fetchComments(String songId);

  Future<void> postComment(String songId, String username, String comment);
}
