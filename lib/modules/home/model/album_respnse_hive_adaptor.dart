import 'package:hive/hive.dart';
import 'album_response.dart';

class AlbumResponseAdapter extends TypeAdapter<AlbumResponse> {
  @override
  final int typeId = 0;

  @override
  AlbumResponse read(BinaryReader reader) {
    return AlbumResponse(
      userId: reader.readInt(),
      id: reader.readInt(),
      title: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, AlbumResponse obj) {
    writer.writeInt(obj.userId ?? 0);
    writer.writeInt(obj.id ?? 0);
    writer.writeString(obj.title ?? "");
  }
}
