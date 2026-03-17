import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../domain/entities/media_entity.dart';

class LocalMediaFile extends Equatable {
  final Uint8List bytes;
  final String fileName;
  final String mimeType;

  const LocalMediaFile({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [bytes, fileName, mimeType];
}

class MediaState extends Equatable {
  final bool isLoading;
  final bool isUploading;
  final List<MediaEntity> mediaList;
  final List<LocalMediaFile> localFiles;
  final String selectedFolder;
  final String? errorMessage;
  final String? successMessage;

  const MediaState({
    this.isLoading = false,
    this.isUploading = false,
    this.mediaList = const [],
    this.localFiles = const [],
    this.selectedFolder = '',
    this.errorMessage,
    this.successMessage,
  });

  MediaState copyWith({
    bool? isLoading,
    bool? isUploading,
    List<MediaEntity>? mediaList,
    List<LocalMediaFile>? localFiles,
    String? selectedFolder,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return MediaState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      mediaList: mediaList ?? this.mediaList,
      localFiles: localFiles ?? this.localFiles,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearSuccess ? null : successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isUploading,
        mediaList,
        localFiles,
        selectedFolder,
        errorMessage,
        successMessage,
      ];
}