import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'w10-practice-56d71-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  List<Song>? _cachedSongs;

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
   

    if (_cachedSongs != null && !forceFetch) {
      return _cachedSongs!;
    }

    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }



      _cachedSongs = result;
      return _cachedSongs!;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<void> likeSong(String id) async {
    final uri = Uri.https(
      'w10-practice-56d71-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$id.json',
    );

  
    await http.patch(
      uri,
      body: json.encode({
        'likes': {'.sv': {'increment': 1}},
      }),
    );
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
}
