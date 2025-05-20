// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$HomeStateCWProxy {
  HomeState isLoading(bool isLoading);

  HomeState error(String? error);

  HomeState albums(List<AlbumResponse> albums);

  HomeState groupedPhotosByAlbum(
    Map<int, List<PhotoResponse>>? groupedPhotosByAlbum,
  );

  HomeState lastUpdatedTime(DateTime? lastUpdatedTime);

  HomeState fakeAlbums(List<AlbumResponse> fakeAlbums);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeState call({
    bool isLoading,
    String? error,
    List<AlbumResponse> albums,
    Map<int, List<PhotoResponse>>? groupedPhotosByAlbum,
    DateTime? lastUpdatedTime,
    List<AlbumResponse> fakeAlbums,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfHomeState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfHomeState.copyWith.fieldName(...)`
class _$HomeStateCWProxyImpl implements _$HomeStateCWProxy {
  const _$HomeStateCWProxyImpl(this._value);

  final HomeState _value;

  @override
  HomeState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  HomeState error(String? error) => this(error: error);

  @override
  HomeState albums(List<AlbumResponse> albums) => this(albums: albums);

  @override
  HomeState groupedPhotosByAlbum(
    Map<int, List<PhotoResponse>>? groupedPhotosByAlbum,
  ) => this(groupedPhotosByAlbum: groupedPhotosByAlbum);

  @override
  HomeState lastUpdatedTime(DateTime? lastUpdatedTime) =>
      this(lastUpdatedTime: lastUpdatedTime);

  @override
  HomeState fakeAlbums(List<AlbumResponse> fakeAlbums) =>
      this(fakeAlbums: fakeAlbums);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `HomeState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// HomeState(...).copyWith(id: 12, name: "My name")
  /// ````
  HomeState call({
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
    Object? albums = const $CopyWithPlaceholder(),
    Object? groupedPhotosByAlbum = const $CopyWithPlaceholder(),
    Object? lastUpdatedTime = const $CopyWithPlaceholder(),
    Object? fakeAlbums = const $CopyWithPlaceholder(),
  }) {
    return HomeState(
      isLoading:
          isLoading == const $CopyWithPlaceholder()
              ? _value.isLoading
              // ignore: cast_nullable_to_non_nullable
              : isLoading as bool,
      error:
          error == const $CopyWithPlaceholder()
              ? _value.error
              // ignore: cast_nullable_to_non_nullable
              : error as String?,
      albums:
          albums == const $CopyWithPlaceholder()
              ? _value.albums
              // ignore: cast_nullable_to_non_nullable
              : albums as List<AlbumResponse>,
      groupedPhotosByAlbum:
          groupedPhotosByAlbum == const $CopyWithPlaceholder()
              ? _value.groupedPhotosByAlbum
              // ignore: cast_nullable_to_non_nullable
              : groupedPhotosByAlbum as Map<int, List<PhotoResponse>>?,
      lastUpdatedTime:
          lastUpdatedTime == const $CopyWithPlaceholder()
              ? _value.lastUpdatedTime
              // ignore: cast_nullable_to_non_nullable
              : lastUpdatedTime as DateTime?,
      fakeAlbums:
          fakeAlbums == const $CopyWithPlaceholder()
              ? _value.fakeAlbums
              // ignore: cast_nullable_to_non_nullable
              : fakeAlbums as List<AlbumResponse>,
    );
  }
}

extension $HomeStateCopyWith on HomeState {
  /// Returns a callable class that can be used as follows: `instanceOfHomeState.copyWith(...)` or like so:`instanceOfHomeState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$HomeStateCWProxy get copyWith => _$HomeStateCWProxyImpl(this);
}
