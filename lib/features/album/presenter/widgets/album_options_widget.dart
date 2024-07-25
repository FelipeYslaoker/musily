import 'dart:math';

import 'package:flutter/material.dart';
import 'package:musily/core/domain/uasecases/get_playable_item_usecase.dart';
import 'package:musily/core/presenter/controllers/core/core_controller.dart';
import 'package:musily/core/presenter/widgets/core_base_dialog.dart';
import 'package:musily/features/_library_module/presenter/controllers/library/library_controller.dart';
import 'package:musily/features/_library_module/presenter/widgets/library_toggler.dart';
import 'package:musily/features/_library_module/presenter/widgets/playlist_adder.dart';
import 'package:musily/features/album/domain/entities/album_entity.dart';
import 'package:musily/features/album/domain/usecases/get_album_usecase.dart';
import 'package:musily/features/album/presenter/widgets/album_tile.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_albums_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_singles_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_tracks_usecase.dart';
import 'package:musily/features/artist/domain/usecases/get_artist_usecase.dart';
import 'package:musily/features/downloader/presenter/controllers/downloader/downloader_controller.dart';
import 'package:musily/features/player/presenter/controller/player/player_controller.dart';
import 'package:musily/features/track/data/models/track_model.dart';

class AlbumOptionsWidget extends StatelessWidget {
  final AlbumEntity album;
  final CoreController coreController;
  final PlayerController playerController;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final LibraryController libraryController;

  const AlbumOptionsWidget({
    required this.album,
    required this.coreController,
    required this.playerController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    // String playlistHash(List<TrackEntity> tracks) {
    //   return tracks.map((track) => track.hash).join('');
    // }

    // Future<List<TrackEntity>> getTracks() async {
    //   late final List<TrackEntity> tracks;
    //   if (album.tracks.isNotEmpty) {
    //     tracks = album.tracks;
    //   } else {
    //     final albumWithTracks = await getAlbumUsecase.exec(album.id);
    //     tracks = albumWithTracks.tracks;
    //   }
    //   return tracks;
    // }

    // bool albumIsInLibrary(AlbumEntity album) {
    //   final libraryItems = libraryController.data.items;
    //   final entities = libraryItems.map((element) => element.value);
    //   final albums = entities.whereType<AlbumEntity>();
    //   final albumIds = albums.map((element) => element.id);
    //   return albumIds.contains(album.id);
    // }

    // String libraryItemId(AlbumEntity album) {
    //   final libraryItems = libraryController.data.items;
    //   final libraryItem =
    //       libraryItems.where((element) => element.value.id == album.id);
    //   if (libraryItem.isNotEmpty) {
    //     return libraryItem.first.id;
    //   }
    //   return '';
    // }

    return Scaffold(
      body: Column(
        children: [
          AlbumTile(
            album: album,
            staticTile: true,
            coreController: coreController,
            playerController: playerController,
            getAlbumUsecase: getAlbumUsecase,
            downloaderController: downloaderController,
            getPlayableItemUsecase: getPlayableItemUsecase,
            libraryController: libraryController,
            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
            getArtistSinglesUsecase: getArtistSinglesUsecase,
            getArtistTracksUsecase: getArtistTracksUsecase,
            getArtistUsecase: getArtistUsecase,
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  downloaderController.builder(
                    builder: (context, data) {
                      final isAlbumDownloading =
                          data.downloadQueue.isNotEmpty &&
                              data.downloadingId == album.id;
                      return ListTile(
                        onTap: () {
                          if (isAlbumDownloading) {
                            libraryController.methods.cancelCollectionDownload(
                              album.tracks,
                              album.id,
                            );
                          } else {
                            libraryController.methods.downloadCollection(
                              album.tracks,
                              album.id,
                            );
                          }
                          Navigator.pop(context);
                        },
                        leading: Icon(
                          isAlbumDownloading
                              ? Icons.cancel_rounded
                              : Icons.download_rounded,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
                        title: Text(
                          isAlbumDownloading ? 'Cancelar download' : 'Baixar',
                        ),
                      );
                    },
                  ),
                  playerController.builder(
                    builder: (context, data) {
                      final isAlbumPlaying = data.playingId == album.id;
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              if (isAlbumPlaying) {
                                if (data.isPlaying) {
                                  await playerController.methods.pause();
                                } else {
                                  await playerController.methods.resume();
                                }
                              } else {
                                await playerController.methods.playPlaylist(
                                  [
                                    ...album.tracks.map(
                                      (track) =>
                                          TrackModel.toMusilyTrack(track),
                                    ),
                                  ],
                                  album.id,
                                  startFrom: 0,
                                );
                                libraryController.methods.updateLastTimePlayed(
                                  album.id,
                                );
                              }
                            },
                            leading: Icon(
                              isAlbumPlaying && data.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.primary,
                            ),
                            title: Text(
                              isAlbumPlaying && data.isPlaying
                                  ? 'Pausar'
                                  : 'Tocar',
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              final random = Random();
                              final randomIndex = random.nextInt(
                                album.tracks.length,
                              );
                              playerController.methods.playPlaylist(
                                [
                                  ...album.tracks.map(
                                    (element) =>
                                        TrackModel.toMusilyTrack(element),
                                  ),
                                ],
                                album.id,
                                startFrom: randomIndex,
                              );
                              Navigator.pop(context);
                              if (!data.shuffleEnabled) {
                                playerController.methods.toggleShuffle();
                              } else {
                                await playerController.methods.toggleShuffle();
                                playerController.methods.toggleShuffle();
                              }
                              libraryController.methods.updateLastTimePlayed(
                                album.id,
                              );
                            },
                            leading: Icon(
                              Icons.shuffle_rounded,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.primary,
                            ),
                            title: const Text(
                              'Tocar aleatoriamente',
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              playerController.methods.addToQueue(
                                [
                                  ...album.tracks.map(
                                    (track) => TrackModel.toMusilyTrack(track),
                                  ),
                                ],
                              );
                              Navigator.pop(context);
                            },
                            leading: Icon(
                              Icons.playlist_add,
                              color: Theme.of(context)
                                  .buttonTheme
                                  .colorScheme
                                  ?.primary,
                            ),
                            title: const Text(
                              'Adicionar à fila',
                              style: TextStyle(
                                color: null,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  PlaylistAdder(
                    libraryController,
                    asyncTracks: () async {
                      if (album.tracks.isNotEmpty) {
                        return album.tracks;
                      }
                      final fetechedAlbum = await getAlbumUsecase.exec(
                        album.id,
                      );
                      return fetechedAlbum?.tracks ?? [];
                    },
                    builder: (context, showAdder) => ListTile(
                      onTap: showAdder,
                      leading: Icon(
                        Icons.queue_music,
                        color:
                            Theme.of(context).buttonTheme.colorScheme?.primary,
                      ),
                      title: const Text(
                        'Adicionar à playlist',
                      ),
                    ),
                  ),
                  LibraryToggler(
                    item: album,
                    libraryController: libraryController,
                    notInLibraryWidget: (context, addToLibrary) {
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          addToLibrary();
                        },
                        leading: Icon(
                          Icons.library_add_rounded,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
                        title: const Text(
                          'Adicionar à bibilioteca',
                        ),
                      );
                    },
                    inLibraryWidget: (context, removeFromLibrary) {
                      return ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          removeFromLibrary();
                        },
                        leading: Icon(
                          Icons.delete,
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme
                              ?.primary,
                        ),
                        title: const Text(
                          'Remover da bibilioteca',
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.share_rounded,
                      color: Theme.of(context).buttonTheme.colorScheme?.primary,
                    ),
                    title: const Text(
                      'Compartilhar',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlbumOptionsBuilder extends StatelessWidget {
  final CoreController coreController;
  final PlayerController playerController;
  final AlbumEntity album;
  final GetAlbumUsecase getAlbumUsecase;
  final DownloaderController downloaderController;
  final GetPlayableItemUsecase getPlayableItemUsecase;
  final GetArtistUsecase getArtistUsecase;
  final GetArtistAlbumsUsecase getArtistAlbumsUsecase;
  final GetArtistTracksUsecase getArtistTracksUsecase;
  final GetArtistSinglesUsecase getArtistSinglesUsecase;
  final LibraryController libraryController;
  final Widget Function(BuildContext context, void Function() showOptions)
      builder;

  const AlbumOptionsBuilder({
    required this.album,
    required this.coreController,
    required this.builder,
    required this.playerController,
    required this.getAlbumUsecase,
    super.key,
    required this.downloaderController,
    required this.getPlayableItemUsecase,
    required this.libraryController,
    required this.getArtistUsecase,
    required this.getArtistAlbumsUsecase,
    required this.getArtistTracksUsecase,
    required this.getArtistSinglesUsecase,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, () {
      coreController.methods.pushModal(
        CoreBaseDialog(
          coreController: coreController,
          child: AlbumOptionsWidget(
            album: album,
            coreController: coreController,
            playerController: playerController,
            getAlbumUsecase: getAlbumUsecase,
            downloaderController: downloaderController,
            getPlayableItemUsecase: getPlayableItemUsecase,
            libraryController: libraryController,
            getArtistAlbumsUsecase: getArtistAlbumsUsecase,
            getArtistSinglesUsecase: getArtistSinglesUsecase,
            getArtistTracksUsecase: getArtistTracksUsecase,
            getArtistUsecase: getArtistUsecase,
          ),
        ),
      );
    });
  }
}
