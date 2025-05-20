// To parse this JSON data, do
//
//     final photoResponse = photoResponseFromJson(jsonString);

import 'dart:convert';

List<PhotoResponse> photoResponseFromJson(String str) => List<PhotoResponse>.from(json.decode(str).map((x) => PhotoResponse.fromJson(x)));

String photoResponseToJson(List<PhotoResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhotoResponse {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  PhotoResponse({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  factory PhotoResponse.fromJson(Map<String, dynamic> json) => PhotoResponse(
    albumId: json["albumId"],
    id: json["id"],
    title: json["title"],
    url: json["url"],
    thumbnailUrl: json["thumbnailUrl"],
  );

  Map<String, dynamic> toJson() => {
    "albumId": albumId,
    "id": id,
    "title": title,
    "url": url,
    "thumbnailUrl": thumbnailUrl,
  };
}
