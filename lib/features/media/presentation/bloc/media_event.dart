import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../domain/entities/media_entity.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object?> get props => [];
}

class LoadMediaEvent extends MediaEvent {
  final String folder;
  final int limit;

  const LoadMediaEvent({
    required this.folder,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [folder, limit];
}

class AddLocalMediaEvent extends MediaEvent {
  final Uint8List bytes;
  final String fileName;
  final String mimeType;

  const AddLocalMediaEvent({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [bytes, fileName, mimeType];
}

class RemoveLocalMediaEvent extends MediaEvent {
  final String fileName;

  const RemoveLocalMediaEvent(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class UploadMediaEvent extends MediaEvent {
  final String folder;
  final String uploadedBy;

  const UploadMediaEvent({
    required this.folder,
    required this.uploadedBy,
  });

  @override
  List<Object?> get props => [folder, uploadedBy];
}

class DeleteMediaEvent extends MediaEvent {
  final MediaEntity media;

  const DeleteMediaEvent(this.media);

  @override
  List<Object?> get props => [media];
}

class ClearMediaMessageEvent extends MediaEvent {
  const ClearMediaMessageEvent();
}