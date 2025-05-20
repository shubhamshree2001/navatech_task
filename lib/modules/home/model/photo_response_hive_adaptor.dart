import 'package:hive/hive.dart';
import 'photo_response.dart';

class PhotoResponseAdapter extends TypeAdapter<PhotoResponse> {
  @override
  final int typeId = 1;

  @override
  PhotoResponse read(BinaryReader reader) {
    return PhotoResponse(
      albumId: reader.readInt(),
      id: reader.readInt(),
      title: reader.readString(),
      url: reader.readString(),
      thumbnailUrl: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, PhotoResponse obj) {
    writer.writeInt(obj.albumId ?? 0);
    writer.writeInt(obj.id ?? 0);
    writer.writeString(obj.title ?? "");
    writer.writeString(obj.url ?? "");
    writer.writeString(obj.thumbnailUrl ?? "");
  }
}
