import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/media_entity.dart';
import '../bloc/media_bloc.dart';
import '../bloc/media_event.dart';
import '../bloc/media_state.dart';
import 'media_dropzone.dart';
import 'media_grid.dart';

class MediaPickerDialog extends StatefulWidget {
  final String folder;
  final String uploadedBy;

  const MediaPickerDialog({
    super.key,
    required this.folder,
    required this.uploadedBy,
  });

  @override
  State<MediaPickerDialog> createState() => _MediaPickerDialogState();
}

class _MediaPickerDialogState extends State<MediaPickerDialog> {
  MediaEntity? selectedMedia;

  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(
          LoadMediaEvent(folder: widget.folder),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 950,
        height: 680,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<MediaBloc, MediaState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
                context.read<MediaBloc>().add(const ClearMediaMessageEvent());
              }

              if (state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.successMessage!)),
                );
                context.read<MediaBloc>().add(const ClearMediaMessageEvent());
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Category Image',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const MediaDropzone(),
                  const SizedBox(height: 16),

                  if (state.localFiles.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.localFiles.map((file) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.image, size: 18),
                              const SizedBox(width: 6),
                              Text(file.fileName),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () {
                                  context.read<MediaBloc>().add(
                                        RemoveLocalMediaEvent(file.fileName),
                                      );
                                },
                                child: const Icon(Icons.close, size: 16),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: state.isUploading
                            ? null
                            : () {
                                context.read<MediaBloc>().add(
                                      UploadMediaEvent(
                                        folder: widget.folder,
                                        uploadedBy: widget.uploadedBy,
                                      ),
                                    );
                              },
                        icon: state.isUploading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload),
                        label: Text(
                          state.isUploading ? 'Uploading...' : 'Upload Images',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Expanded(
                    child: state.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : MediaGrid(
                            mediaList: state.mediaList,
                            selectedMedia: selectedMedia,
                            onSelect: (media) {
                              setState(() {
                                selectedMedia = media;
                              });
                            },
                          ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: selectedMedia == null
                            ? null
                            : () => Navigator.pop(context, selectedMedia),
                        child: const Text('Use Image'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}