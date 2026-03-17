


import 'dart:typed_data';

import '../entities/media_entity.dart';

abstract class MediaRepository {
  Future<List<MediaEntity>> fetchMediaByFolder(String folder, {int limit = 20});

  Future<MediaEntity> uploadMedia({
    required Uint8List fileBytes,
    required String fileName,
    required String mimeType,
    required String folder,
    required String uploadedBy,
  });

  Future<void> deleteMedia(MediaEntity media);
}
// abstract class MediaRepository {
//   Future<List<MediaEntity>> fetchMediaByFolder(String folder, {int limit = 20});
//   Future<MediaEntity> uploadMedia({
//     required Uint8List fileBytes,
//     required String fileName,
//     required String mimeType,
//     required String folder,
//   });
//   Future<void> deleteMedia(MediaEntity media);
// }