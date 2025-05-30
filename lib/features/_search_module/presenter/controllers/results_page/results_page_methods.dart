import 'package:musily/features/track/domain/entities/track_entity.dart';

class ResultsPageMethods {
  final Future<void> Function(
    String query, {
    required int limit,
    required int page,
  }) searchTracks;
  final Future<void> Function(
    String query,
  ) searchAlbums;
  final Future<void> Function(
    String query,
  ) searchArtists;

  final Future<void> Function(String trackId) loadTrack;

  final Future<void> Function(TrackEntity track) play;
  final Future<void> Function(List<TrackEntity> tracks) addToQueue;

  ResultsPageMethods({
    required this.searchTracks,
    required this.searchAlbums,
    required this.searchArtists,
    required this.loadTrack,
    required this.play,
    required this.addToQueue,
  });
}
