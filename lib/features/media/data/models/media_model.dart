import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/media_entity.dart';

class MediaModel extends MediaEntity {
  const MediaModel({
    required super.id,
    required super.url,
    required super.folder,
    required super.filename,
    required super.uploadedBy,
    super.sizeBytes,
    super.fullPath,
    super.createdAt,
    super.updatedAt,
    super.contentType,
  });

  factory MediaModel.fromMap(Map<String, dynamic> map, String docId) {
    return MediaModel(
      id: docId,
      url: map['url'] ?? '',
      folder: map['folder'] ?? '',
      filename: map['filename'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      sizeBytes: map['sizeBytes'],
      fullPath: map['fullPath'],
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
      contentType: map['contentType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'folder': folder,
      'filename': filename,
      'uploadedBy': uploadedBy,
      'sizeBytes': sizeBytes,
      'fullPath': fullPath,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'contentType': contentType,
    };
  }

  factory MediaModel.fromEntity(MediaEntity entity) {
    return MediaModel(
      id: entity.id,
      url: entity.url,
      folder: entity.folder,
      filename: entity.filename,
      uploadedBy: entity.uploadedBy,
      sizeBytes: entity.sizeBytes,
      fullPath: entity.fullPath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      contentType: entity.contentType,
    );
  }
}