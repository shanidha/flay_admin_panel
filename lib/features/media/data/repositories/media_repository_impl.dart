import 'dart:typed_data';

import '../../domain/entities/media_entity.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_remote_data_source.dart';
import '../datasources/media_storage_data_source.dart';
import '../models/media_model.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;
  final MediaStorageDataSource storageDataSource;

  MediaRepositoryImpl({
    required this.remoteDataSource,
    required this.storageDataSource,
  });

  @override
  Future<List<MediaEntity>> fetchMediaByFolder(String folder,
      {int limit = 20}) async {
    return remoteDataSource.fetchMediaByFolder(folder, limit: limit);
  }

  @override
  Future<MediaEntity> uploadMedia({
    required Uint8List fileBytes,
    required String fileName,
    required String mimeType,
    required String folder,
    required String uploadedBy,
  }) async {
    final storageResult = await storageDataSource.uploadFile(
      fileBytes: fileBytes,
      fileName: fileName,
      mimeType: mimeType,
      folder: folder,
    );

    final model = MediaModel(
      id: '',
      url: storageResult.url,
      folder: folder,
      filename: fileName,
      uploadedBy: uploadedBy,
      sizeBytes: storageResult.sizeBytes,
      fullPath: storageResult.fullPath,
      createdAt: storageResult.timeCreated ?? DateTime.now(),
      updatedAt: storageResult.updatedTime ?? DateTime.now(),
      contentType: storageResult.contentType ?? mimeType,
    );

    final docId = await remoteDataSource.createMediaDocument(model);

    return MediaModel(
      id: docId,
      url: model.url,
      folder: model.folder,
      filename: model.filename,
      uploadedBy: model.uploadedBy,
      sizeBytes: model.sizeBytes,
      fullPath: model.fullPath,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      contentType: model.contentType,
    );
  }

  @override
  Future<void> deleteMedia(MediaEntity media) async {
    if (media.fullPath != null && media.fullPath!.isNotEmpty) {
      await storageDataSource.deleteFile(media.fullPath!);
    }

    if (media.id.isNotEmpty) {
      await remoteDataSource.deleteMediaDocument(media.id);
    }
  }
}