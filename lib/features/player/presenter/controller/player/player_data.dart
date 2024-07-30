import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily_player/musily_entities.dart';
import 'package:musily_player/musily_player.dart';

class Lyrics {
  final String trackId;
  final String? lyrics;

  Lyrics({
    required this.trackId,
    required this.lyrics,
  });
}

class PlayerData extends BaseControllerData {
  List<MusilyTrack> queue;
  String playingId;
  MusilyTrack? currentPlayingItem;
  bool loadingTrackData;
  bool isPlaying;
  bool loadRequested;
  bool seeking;
  bool shuffleEnabled;
  MusilyRepeatMode repeatMode;
  bool isBuffering;

  bool showLyrics;
  bool loadingLyrics;
  Lyrics lyrics;
  bool syncedLyrics;

  bool mediaAvailable;
  List<String> tracksFromSmartQueue;
  bool loadingSmartQueue;

  PlayerData({
    required this.queue,
    required this.playingId,
    this.currentPlayingItem,
    required this.loadingTrackData,
    required this.isPlaying,
    required this.loadRequested,
    required this.seeking,
    required this.mediaAvailable,
    required this.shuffleEnabled,
    required this.repeatMode,
    required this.isBuffering,
    required this.showLyrics,
    required this.loadingLyrics,
    required this.lyrics,
    required this.syncedLyrics,
    required this.tracksFromSmartQueue,
    required this.loadingSmartQueue,
  });

  @override
  PlayerData copyWith({
    List<MusilyTrack>? queue,
    MusilyTrack? currentPlayingItem,
    bool? loadingTrackData,
    bool? isPlaying,
    bool? loadRequested,
    bool? seeking,
    bool? mediaAvailable,
    bool? shuffleEnabled,
    MusilyRepeatMode? repeatMode,
    bool? isBuffering,
    String? playingId,
    bool? showLyrics,
    bool? loadingLyrics,
    Lyrics? lyrics,
    bool? syncedLyrics,
    List<String>? tracksFromSmartQueue,
    bool? loadingSmartQueue,
  }) {
    return PlayerData(
      playingId: playingId ?? this.playingId,
      queue: queue ?? this.queue,
      currentPlayingItem: currentPlayingItem ?? this.currentPlayingItem,
      loadingTrackData: loadingTrackData ?? this.loadingTrackData,
      isPlaying: isPlaying ?? this.isPlaying,
      loadRequested: loadRequested ?? this.loadRequested,
      seeking: seeking ?? this.seeking,
      mediaAvailable: mediaAvailable ?? this.mediaAvailable,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      repeatMode: repeatMode ?? this.repeatMode,
      isBuffering: isBuffering ?? this.isBuffering,
      showLyrics: showLyrics ?? this.showLyrics,
      loadingLyrics: loadingLyrics ?? this.loadingLyrics,
      lyrics: lyrics ?? this.lyrics,
      syncedLyrics: syncedLyrics ?? this.syncedLyrics,
      tracksFromSmartQueue: tracksFromSmartQueue ?? this.tracksFromSmartQueue,
      loadingSmartQueue: loadingSmartQueue ?? this.loadingSmartQueue,
    );
  }
}
