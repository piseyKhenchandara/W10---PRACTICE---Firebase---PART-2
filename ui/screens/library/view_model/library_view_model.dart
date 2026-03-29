import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();

  AsyncValue<void> likeValue = AsyncValue.success(null);

  final Set<String> _likedSongIds = {};


  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  Future<void> fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    data = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs
      List<Song> songs = await songRepository.fetchSongs(forceFetch: forceFetch);

    
      // 2- Fetch artist
      List<Artist> artists = await artistRepository.fetchArtists(forceFetch: forceFetch);

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

      this.data = AsyncValue.success(data);
    } catch (e) {
      // 3- Fetch is unsucessfull
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool hasLiked(String songId) => _likedSongIds.contains(songId);

  Future<void> likeSong(String songId) async {
    if (_likedSongIds.contains(songId)) return;

    likeValue = AsyncValue.loading();
    notifyListeners();

    try {
      await songRepository.likeSong(songId);
      _likedSongIds.add(songId);
      likeValue = AsyncValue.success(null);
      await fetchSong(forceFetch: true);
    } catch (e) {
      likeValue = AsyncValue.error(e);
      notifyListeners();
    }
  }
  
  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
