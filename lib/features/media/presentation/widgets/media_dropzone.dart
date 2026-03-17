import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../bloc/media_bloc.dart';
import '../bloc/media_event.dart';

class MediaDropzone extends StatefulWidget {
  const MediaDropzone({super.key});

  @override
  State<MediaDropzone> createState() => _MediaDropzoneState();
}

class _MediaDropzoneState extends State<MediaDropzone> {
  DropzoneViewController? controller;
  bool isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? Colors.blue : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DropzoneView(
            operation: DragOperation.copy,
            mime: const ['image/jpeg', 'image/png', 'image/webp'],
            onCreated: (ctrl) => controller = ctrl,
            onHover: () {
              setState(() => isHighlighted = true);
            },
            onLeave: () {
              setState(() => isHighlighted = false);
            },
            onDropFile: (file) async {
              setState(() => isHighlighted = false);

              final dropzone = controller;
              if (dropzone == null) return;

              final bytes = await dropzone.getFileData(file);
              final fileName = await dropzone.getFilename(file);
              final mimeType = await dropzone.getFileMIME(file);

              if (!mounted) return;

              context.read<MediaBloc>().add(
                    AddLocalMediaEvent(
                      bytes: Uint8List.fromList(bytes),
                      fileName: fileName,
                      mimeType: mimeType,
                    ),
                  );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_upload_outlined, size: 48),
              const SizedBox(height: 10),
              const Text(
                'Drag and drop images here',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () async {
                  final dropzone = controller;
                  if (dropzone == null) return;

                  final files = await dropzone.pickFiles(
                    multiple: true,
                    mime: ['image/jpeg', 'image/png', 'image/webp'],
                  );

                  for (final file in files) {
                    final bytes = await dropzone.getFileData(file);
                    final fileName = await dropzone.getFilename(file);
                    final mimeType = await dropzone.getFileMIME(file);

                    if (!mounted) return;

                    context.read<MediaBloc>().add(
                          AddLocalMediaEvent(
                            bytes: Uint8List.fromList(bytes),
                            fileName: fileName,
                            mimeType: mimeType,
                          ),
                        );
                  }
                },
                child: const Text('Browse Images'),
              )
            ],
          ),
        ],
      ),
    );
  }
}