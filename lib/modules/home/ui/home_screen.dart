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
  late ScrollController _scrollControllerHorizontal;
  static const int _virtualItemCountVertical = 1000000;


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
    _scrollControllerVertical = ScrollController(initialScrollOffset: 0.0);
    _scrollControllerHorizontal = ScrollController(initialScrollOffset: 0.0);
  }



  @override
  void dispose() {
    _scrollControllerVertical.dispose();
    _scrollControllerHorizontal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        List<AlbumResponse> albums = homeCubit.state.albums;
        final int albumLength = albums.length;
        return RefreshIndicator(
          onRefresh: homeCubit.onPullDownRefresh,
          child: Scaffold(
            appBar: AppBar(title: Text('Albums with Photos')),
            body:
                albums.isEmpty || homeCubit.state.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      controller: _scrollControllerVertical,
                      itemCount: _virtualItemCountVertical,
                      itemBuilder: (context, index) {
                        final actualIndexVertical = index % albumLength;
                        final album = albums[actualIndexVertical];
                        final List<PhotoResponse> photos =
                            homeCubit.state.groupedPhotosByAlbum?[album.id] ??
                            [];
                        final int photosLength = photos.length;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.w,
                            horizontal: 16.w,
                          ),
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
                              SizedBox(
                                height: 121.w,
                                child: ListView.builder(
                                  controller: _scrollControllerHorizontal,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: photosLength > 0 ? 100000 : 0,
                                  itemBuilder: (context, photoIndex) {
                                    final actualIndexHorizontal =
                                        photoIndex % photosLength;
                                    final photo = photos[actualIndexHorizontal];
                                    return Padding(
                                      padding: EdgeInsets.only(right: 16.w),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                          vertical: 2.w,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 1.w,
                                          ),
                                        ),
                                        width: 100.w,
                                        height: 121.w,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
        );
      },
    );
  }
}
