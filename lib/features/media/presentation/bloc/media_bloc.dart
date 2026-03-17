import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/media_entity.dart';
import '../../domain/usecases/delete_media.dart';
import '../../domain/usecases/fetch_media_by_folder.dart';
import '../../domain/usecases/upload_media.dart';
import 'media_event.dart';
import 'media_state.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final FetchMediaByFolder fetchMediaByFolder;
  final UploadMedia uploadMedia;
  final DeleteMedia deleteMedia;

  MediaBloc({
    required this.fetchMediaByFolder,
    required this.uploadMedia,
    required this.deleteMedia,
  }) : super(const MediaState()) {
    on<LoadMediaEvent>(_onLoadMedia);
    on<AddLocalMediaEvent>(_onAddLocalMedia);
    on<RemoveLocalMediaEvent>(_onRemoveLocalMedia);
    on<UploadMediaEvent>(_onUploadMedia);
    on<DeleteMediaEvent>(_onDeleteMedia);
    on<ClearMediaMessageEvent>(_onClearMessage);
  }

  Future<void> _onLoadMedia(
    LoadMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      selectedFolder: event.folder,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final result =
          await fetchMediaByFolder(event.folder, limit: event.limit);

      emit(state.copyWith(
        isLoading: false,
        mediaList: result,
        selectedFolder: event.folder,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onAddLocalMedia(
    AddLocalMediaEvent event,
    Emitter<MediaState> emit,
  ) {
    final updated = List<LocalMediaFile>.from(state.localFiles)
      ..add(
        LocalMediaFile(
          bytes: event.bytes,
          fileName: event.fileName,
          mimeType: event.mimeType,
        ),
      );

    emit(state.copyWith(localFiles: updated));
  }

  void _onRemoveLocalMedia(
    RemoveLocalMediaEvent event,
    Emitter<MediaState> emit,
  ) {
    final updated =
        state.localFiles.where((e) => e.fileName != event.fileName).toList();

    emit(state.copyWith(localFiles: updated));
  }

  Future<void> _onUploadMedia(
    UploadMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    if (state.localFiles.isEmpty) return;

    emit(state.copyWith(
      isUploading: true,
      clearError: true,
      clearSuccess: true,
    ));

    try {
      final uploadedItems = <MediaEntity>[];

      for (final file in state.localFiles) {
        final uploaded = await uploadMedia(
          fileBytes: file.bytes,
          fileName: file.fileName,
          mimeType: file.mimeType,
          folder: event.folder,
          uploadedBy: event.uploadedBy,
        );
        uploadedItems.add(uploaded);
      }

      emit(state.copyWith(
        isUploading: false,
        localFiles: const [],
        mediaList: [...uploadedItems, ...state.mediaList],
        successMessage: 'Media uploaded successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteMedia(
    DeleteMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    try {
      await deleteMedia(event.media);

      final updated =
          state.mediaList.where((item) => item.id != event.media.id).toList();

      emit(state.copyWith(
        mediaList: updated,
        successMessage: 'Media deleted successfully',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onClearMessage(
    ClearMediaMessageEvent event,
    Emitter<MediaState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
}