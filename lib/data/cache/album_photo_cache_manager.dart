import 'package:hive/hive.dart';
import 'package:navatech_task/modules/home/model/album_response.dart';
import 'package:navatech_task/modules/home/model/photo_response.dart';

class AlbumCacheManager {
  static const String boxName = 'albumsBox';

  static Future<void> saveAlbums(List<AlbumResponse> albums) async {
    var box = Hive.box<AlbumResponse>(boxName);
    await box.clear();
    await box.addAll(albums);
  }

  static List<AlbumResponse> loadAlbums() {
    var box = Hive.box<AlbumResponse>(boxName);
    return box.values.toList();
  }
}

class PhotoCacheManager {
  static const String boxName = 'photosBox';

  static Future<void> savePhotos(List<PhotoResponse> photos) async {
    var box = Hive.box<PhotoResponse>(boxName);
    await box.clear();
    await box.addAll(photos);
  }

  static List<PhotoResponse> loadPhotos() {
    var box = Hive.box<PhotoResponse>(boxName);
    return box.values.toList();
  }
}
