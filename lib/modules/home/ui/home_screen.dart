import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:navatech_task/modules/home/bloc/home_cubit.dart';
import 'package:navatech_task/modules/home/model/album_response.dart';
import 'package:navatech_task/modules/home/model/photo_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _infiniteIndex = 100000;
  final Map<int, ScrollController> _horizontalControllers = {};

  void updateDataNeeded() {
    context.read<HomeCubit>().updateDataSilentlyIfNeeded();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateDataNeeded();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateDataNeeded();
  }

  @override
  void initState() {
    super.initState();
    final HomeCubit homeCubit = context.read<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < homeCubit.state.albums.length; i++) {
        _horizontalControllers[i] = ScrollController(
          initialScrollOffset: _infiniteIndex * 100,
        );
      }
    });
  }

  @override
  void dispose() {
    for (var c in _horizontalControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        List<AlbumResponse> albums = homeCubit.state.albums;
        List<AlbumResponse> fakeAlbums = homeCubit.state.fakeAlbums;
        return Scaffold(
          appBar: AppBar(title: Text('Albums with Photos')),
          body:
              albums.isEmpty || homeCubit.state.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : albumsListWidget(fakeAlbums, homeCubit),
        );
      },
    );
  }

  Widget albumsListWidget(List<AlbumResponse> fakeAlbums, HomeCubit homeCubit) {
    return ListView.builder(
      controller: ScrollController(initialScrollOffset: _infiniteIndex * 120),
      itemExtent: 120,
      itemBuilder: (context, index) {
        final vIndex = index % homeCubit.state.albums.length;
        final album = homeCubit.state.albums[vIndex];
        final List<PhotoResponse> photos =
            homeCubit.state.groupedPhotosByAlbum?[album.id] ?? [];
        final int photosLength = photos.length;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.id.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gap(4.w),
                  Expanded(
                    child: Text(
                      album.title ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              photosListWidget(photosLength, photos, vIndex),
            ],
          ),
        );
      },
    );
  }

  Widget photosListWidget(
    int photosLength,
    List<PhotoResponse> photos,
    int vIndex,
  ) {
    return SizedBox(
      height: 55.w,
      child: ListView.builder(
        controller: _horizontalControllers.putIfAbsent(
          vIndex,
          () => ScrollController(initialScrollOffset: _infiniteIndex * 100),
        ),
        scrollDirection: Axis.horizontal,
        itemExtent: 100,
        itemBuilder: (context, photoIndex) {
          final hIndex = photoIndex % photosLength;
          final photo = photos[hIndex];
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.w),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.id.toString() ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    photo.title ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
