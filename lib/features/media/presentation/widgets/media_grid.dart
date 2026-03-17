import 'package:flutter/material.dart';

import '../../domain/entities/media_entity.dart';

class MediaGrid extends StatelessWidget {
  final List<MediaEntity> mediaList;
  final MediaEntity? selectedMedia;
  final ValueChanged<MediaEntity> onSelect;

  const MediaGrid({
    super.key,
    required this.mediaList,
    required this.selectedMedia,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (mediaList.isEmpty) {
      return const Center(
        child: Text('No media found'),
      );
    }

    return GridView.builder(
      itemCount: mediaList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final media = mediaList[index];
        final isSelected = selectedMedia?.id == media.id;

        return GestureDetector(
          onTap: () => onSelect(media),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      media.url,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    media.filename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}