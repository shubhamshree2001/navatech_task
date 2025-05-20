part of 'home_cubit.dart';

@CopyWith()
class HomeState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<AlbumResponse> albums;
  final Map<int, List<PhotoResponse>>? groupedPhotosByAlbum;
  final DateTime? lastUpdatedTime;

  const HomeState({
    this.isLoading = false,
    this.error,
    this.albums = const[],
    this.groupedPhotosByAlbum,
    this.lastUpdatedTime,
  });

  @override
  List<Object?> get props => [
    isLoading,
    error,
    albums,
    groupedPhotosByAlbum,
    lastUpdatedTime,
  ];
}
