import 'package:flutter/material.dart';

import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final Artist artist;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();
  AsyncValue<List<Comment>> commentsValue = AsyncValue.loading();
  AsyncValue<void> postCommentValue = AsyncValue.success(null);

  Song? selectedSong;

  ArtistDetailViewModel({
    required this.songRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() async {
    await _fetchSongs();
  }

  Future<void> _fetchSongs() async {
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 1 - Fetch all songs and filter by artistId
      final allSongs = await songRepository.fetchSongs();
      final artistSongs = allSongs.where((s) => s.artistId == artist.id).toList();

      songsValue = AsyncValue.success(artistSongs);

      // 2 - Auto-select first song and load its comments
      if (artistSongs.isNotEmpty) {
        selectedSong = artistSongs.first;
        await fetchComments(selectedSong!.id);
      }
    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void selectSong(Song song) {
    selectedSong = song;
    notifyListeners();
    fetchComments(song.id);
  }

  Future<void> fetchComments(String songId) async {
    commentsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final comments = await songRepository.fetchComments(songId);
      commentsValue = AsyncValue.success(comments);
    } catch (e) {
      commentsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  Future<void> postComment(String username, String comment) async {
    if (selectedSong == null) return;

    postCommentValue = AsyncValue.loading();
    notifyListeners();

    try {
      await songRepository.postComment(selectedSong!.id, username, comment);
      postCommentValue = AsyncValue.success(null);
      // Refresh comments after posting
      await fetchComments(selectedSong!.id);
    } catch (e) {
      postCommentValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
}
