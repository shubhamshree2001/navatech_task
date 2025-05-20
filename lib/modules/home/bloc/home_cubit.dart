import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:navatech_task/data/cache/album_photo_cache_manager.dart';
import 'package:navatech_task/data/urls.dart';
import 'package:navatech_task/modules/home/model/album_response.dart';
import 'package:navatech_task/modules/home/model/photo_response.dart';
import 'package:navatech_task/services/get_it_service.dart';

part 'home_cubit.g.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setIsLoading(bool isLoading) {
    emit(state.copyWith(isLoading: isLoading));
  }

  Future<void> onPullDownRefresh() async {
    await fetchAllHomeData();
  }

  Future<void> loadAndCacheAlbumsAndPhotos() async {
    final cachedAlbums = AlbumCacheManager.loadAlbums();
    final cachedPhotos = PhotoCacheManager.loadPhotos();
    if (cachedAlbums.isNotEmpty && cachedPhotos.isNotEmpty) {
      Map<int, List<PhotoResponse>> groupedByAlbum = groupPhotosByAlbum(
        cachedPhotos,
      );
      emit(
        state.copyWith(
          albums: cachedAlbums,
          fakeAlbums: [cachedAlbums.last, ...cachedAlbums, cachedAlbums.first],
          groupedPhotosByAlbum: groupedByAlbum,
        ),
      );
      updateDataSilentlyIfNeeded();
    } else {
      await fetchAllHomeData();
    }
  }

  Future<void> updateDataSilentlyIfNeeded() async {
    final DateTime? lastUpdatedDateTime =
        await navaTechStorage.getLastUpdatedDateTime();
    emit(state.copyWith(lastUpdatedTime: lastUpdatedDateTime));
    final DateTime now = DateTime.now();
    final DateTime lastUpdated =
        state.lastUpdatedTime ??
        now.subtract(const Duration(hours: 1, seconds: 1));
    final diff = now.difference(lastUpdated).inSeconds;
    if (diff >= 3600) {
      await fetchAllHomeData(true);
    }
  }

  Future<void> fetchAllHomeData([bool isSilenceUpdate = false]) async {
    print("fetched data is called");
    if (!isSilenceUpdate) {
      setIsLoading(true);
    }
    List<Future<void>> futures = [fetchAlbums(), fetchPhotos()];
    try {
      await Future.wait(futures);
      navaTechStorage.saveLastUpdatedDateTime();
      setIsLoading(false);
    } catch (e) {
      print('An error occurred while fetching home data: $e');
      setIsLoading(false);
    }
  }

  Future<void> fetchAlbums() async {
    try {
      final response = await http.get(Uri.parse(Urls.getAlbums));
      if (response.statusCode == 200) {
        List<AlbumResponse> albums = albumResponseFromJson(response.body);
        await AlbumCacheManager.saveAlbums(albums);
        emit(
          state.copyWith(
            albums: albums,
            fakeAlbums: [albums.last, ...albums, albums.first],
          ),
        );
      } else {
        print('Failed to load albums. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching albums: $e');
    }
  }

  Future<void> fetchPhotos() async {
    try {
      final response = await http.get(Uri.parse(Urls.getPhotos));
      if (response.statusCode == 200) {
        List<PhotoResponse> photos = photoResponseFromJson(response.body);
        await PhotoCacheManager.savePhotos(photos);
        Map<int, List<PhotoResponse>> groupedByAlbum = groupPhotosByAlbum(
          photos,
        );
        emit(state.copyWith(groupedPhotosByAlbum: groupedByAlbum));
      } else {
        print('Failed to load photos. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching photos: $e');
    }
  }

  Map<int, List<PhotoResponse>> groupPhotosByAlbum(List<PhotoResponse> photos) {
    final Map<int, List<PhotoResponse>> grouped = {};
    for (var photo in photos) {
      final albumId = photo.albumId ?? 0;
      if (!grouped.containsKey(albumId)) {
        grouped[albumId] = [];
      }
      grouped[albumId]!.add(photo);
    }
    return grouped;
  }
}
