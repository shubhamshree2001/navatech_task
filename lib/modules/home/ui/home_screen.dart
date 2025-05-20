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
  late ScrollController _scrollControllerVertical;
  final Map<int, ScrollController> _horizontalControllers = {};
  final Map<int, bool> _isHorizontalAnimating = {};

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
    // Initialize vertical scroll controller
    final HomeCubit homeCubit = context.read<HomeCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollControllerVertical.hasClients) {
        // Scroll to the actual first item (index 1)
        _scrollToIndexVertical(1, homeCubit.state.fakeAlbums.length);
      }
    });
    _scrollControllerVertical =
        ScrollController()..addListener(_handleVerticalScroll);
  }

  void _handleVerticalScroll() {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    if (!_scrollControllerVertical.hasClients) return;
    final position = _scrollControllerVertical.position;
    if (!position.atEdge) return;
    final offset = position.pixels;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Top: user scrolled to fake first item
      if (offset <= position.minScrollExtent + 10) {
        // Jump to actual last item (original.length)
        _scrollToIndexVertical(
          homeCubit.state.albums.length,
          homeCubit.state.fakeAlbums.length,
        );
      }
      // Bottom: user scrolled to fake last item
      else if (offset >= position.maxScrollExtent - 10) {
        // Jump to actual first item (index 1)
        _scrollToIndexVertical(1, homeCubit.state.fakeAlbums.length);
      }
    });
  }

  void _scrollToIndexVertical(int index, int fakeAlbumLength) {
    final position = _scrollControllerVertical.position;
    final targetOffset =
        position.maxScrollExtent * index / (fakeAlbumLength - 1);
    _scrollControllerVertical.jumpTo(targetOffset);
  }

  void _animateHorizontal(int albumId, double target) async {
    _isHorizontalAnimating[albumId] = true;
    await _horizontalControllers[albumId]?.animateTo(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    _isHorizontalAnimating[albumId] = false;
  }

  ScrollController _getOrCreateHorizontalController(int albumId) {
    return _horizontalControllers.putIfAbsent(albumId, () {
      final controller = ScrollController();
      _isHorizontalAnimating[albumId] = false;

      controller.addListener(() {
        final isAnimating = _isHorizontalAnimating[albumId] ?? false;
        if (!controller.hasClients || isAnimating) return;

        final offset = controller.offset;
        final position = controller.position;
        const threshold = 50.0;

        if (offset <= position.minScrollExtent + threshold) {
          _animateHorizontal(albumId, position.maxScrollExtent - threshold);
        } else if (offset >= position.maxScrollExtent - threshold) {
          _animateHorizontal(albumId, position.minScrollExtent + threshold);
        }
      });

      return controller;
    });
  }

  @override
  void dispose() {
    _scrollControllerVertical.dispose();
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
      controller: _scrollControllerVertical,
      itemCount: fakeAlbums.length,
      itemBuilder: (context, index) {
        final album = fakeAlbums[index];
        final List<PhotoResponse> photos =
            homeCubit.state.groupedPhotosByAlbum?[album.id] ?? [];
        final int photosLength = photos.length;
        //Controller per album (dynamic)
        final controller =
            album.id != null
                ? _getOrCreateHorizontalController(album.id!)
                : ScrollController();
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              photosListWidget(controller, photosLength, photos),
            ],
          ),
        );
      },
    );
  }

  Widget photosListWidget(
    ScrollController controller,
    int photosLength,
    List<PhotoResponse> photos,
  ) {
    return SizedBox(
      height: 121.w,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: photosLength,
        itemBuilder: (context, photoIndex) {
          final photo = photos[photoIndex];
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.w),
              ),
              width: 100.w,
              height: 121.w,
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
                    maxLines: 5,
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
