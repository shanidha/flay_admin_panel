class MediaEntity {
  final String id;
  final String url;
  final String folder;
  final String filename;
  final String uploadedBy;
  final int? sizeBytes;
  final String? fullPath;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? contentType;

  const MediaEntity({
    required this.id,
    required this.url,
    required this.folder,
    required this.filename,
    required this.uploadedBy,
    this.sizeBytes,
    this.fullPath,
    this.createdAt,
     this.updatedAt,
    this.contentType,
  });
}