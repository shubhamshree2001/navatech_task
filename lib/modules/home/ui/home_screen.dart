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
  bool _isAnimatingVertical = false;

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
    _scrollControllerVertical =
        ScrollController()..addListener(_handleVerticalScroll);
  }

  void _animateVertical(double target) async {
    _isAnimatingVertical = true;
    await _scrollControllerVertical.animateTo(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    _isAnimatingVertical = false;
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

  void _handleVerticalScroll() {
    if (!_scrollControllerVertical.hasClients || _isAnimatingVertical) return;

    final offset = _scrollControllerVertical.offset;
    final position = _scrollControllerVertical.position;
    const threshold = 50.0;

    if (offset <= position.minScrollExtent + threshold) {
      _animateVertical(position.maxScrollExtent - threshold);
    } else if (offset >= position.maxScrollExtent - threshold) {
      _animateVertical(position.minScrollExtent + threshold);
    }
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
        return Scaffold(
          appBar: AppBar(title: Text('Albums with Photos')),
          body:
              albums.isEmpty || homeCubit.state.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : albumsListWidget(albums, homeCubit),
        );
      },
    );
  }

  Widget albumsListWidget(List<AlbumResponse> albums, HomeCubit homeCubit) {
    return ListView.builder(
      controller: _scrollControllerVertical,
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
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
