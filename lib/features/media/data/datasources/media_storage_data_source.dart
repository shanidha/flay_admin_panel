import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class MediaUploadResult {
  final String url;
  final String fullPath;
  final int? sizeBytes;
  final String? contentType;
  final DateTime? timeCreated;
  final DateTime? updatedTime;

  MediaUploadResult({
    required this.url,
    required this.fullPath,
    required this.sizeBytes,
    required this.contentType,
    required this.timeCreated,
    required this.updatedTime,
  });
}

abstract class MediaStorageDataSource {
  Future<MediaUploadResult> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String mimeType,
    required String folder,
  });

  Future<void> deleteFile(String fullPath);
}

class MediaStorageDataSourceImpl implements MediaStorageDataSource {
  final FirebaseStorage storage;
  final Uuid uuid;

  MediaStorageDataSourceImpl({
    required this.storage,
    required this.uuid,
  });

  @override
  Future<MediaUploadResult> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String mimeType,
    required String folder,
  }) async {
    final uniqueName = '${uuid.v4()}_$fileName';
    final path = '$folder/$uniqueName';

    final ref = storage.ref().child(path);

    final metadata = SettableMetadata(contentType: mimeType);

    final taskSnapshot = await ref.putData(fileBytes, metadata);
    final downloadUrl = await ref.getDownloadURL();
    final fullMetadata = await taskSnapshot.ref.getMetadata();

    return MediaUploadResult(
      url: downloadUrl,
      fullPath: ref.fullPath,
      sizeBytes: fullMetadata.size,
      contentType: fullMetadata.contentType,
      timeCreated: fullMetadata.timeCreated,
      updatedTime: fullMetadata.updated,
    );
  }

  @override
  Future<void> deleteFile(String fullPath) async {
    await storage.ref().child(fullPath).delete();
  }
}