import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/media_bloc.dart';
import '../bloc/media_event.dart';
import '../bloc/media_state.dart';
import '../widgets/media_dropzone.dart';
import '../widgets/media_grid.dart';

class MediaPage extends StatefulWidget {
  final String folder;
  final String uploadedBy;

  const MediaPage({
    super.key,
    required this.folder,
    required this.uploadedBy,
  });

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(
          LoadMediaEvent(folder: widget.folder),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Manager'),
      ),
      body: Padding(
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
              children: [
                const MediaDropzone(),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: state.localFiles.isEmpty || state.isUploading
                        ? null
                        : () {
                            context.read<MediaBloc>().add(
                                  UploadMediaEvent(
                                    folder: widget.folder,
                                    uploadedBy: widget.uploadedBy,
                                  ),
                                );
                          },
                    child: Text(state.isUploading ? 'Uploading...' : 'Upload'),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : MediaGrid(
                          mediaList: state.mediaList,
                          selectedMedia: null,
                          onSelect: (_) {},
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}