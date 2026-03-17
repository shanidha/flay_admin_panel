import 'dart:typed_data';
import '../entities/media_entity.dart';
import '../repositories/media_repository.dart';

class UploadMedia {
  final MediaRepository repository;

  UploadMedia(this.repository);

  Future<MediaEntity> call({
    required Uint8List fileBytes,
    required String fileName,
    required String mimeType,
    required String folder,  required String uploadedBy,
  }) {
    return repository.uploadMedia(
      fileBytes: fileBytes,
      fileName: fileName,
      mimeType: mimeType,
      folder: folder, uploadedBy: uploadedBy,
    );
  }
}