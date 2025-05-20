import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navatech_task/data/utils/app_storage.dart';
import 'package:navatech_task/modules/home/model/album_respnse_hive_adaptor.dart';
import 'package:navatech_task/modules/home/model/album_response.dart';
import 'package:navatech_task/modules/home/model/photo_response.dart';
import 'package:navatech_task/modules/home/model/photo_response_hive_adaptor.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(AlbumResponseAdapter());
  Hive.registerAdapter(PhotoResponseAdapter());
  await Hive.openBox<AlbumResponse>('albumsBox');
  await Hive.openBox<PhotoResponse>('photosBox');

  getIt.registerLazySingleton(() => AppStorage());
}

/// Global Getters
AppStorage get navaTechStorage => getIt.get<AppStorage>();
