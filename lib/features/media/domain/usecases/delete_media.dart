import '../entities/media_entity.dart';
import '../repositories/media_repository.dart';

class DeleteMedia {
  final MediaRepository repository;

  DeleteMedia(this.repository);

  Future<void> call(MediaEntity media) {
    return repository.deleteMedia(media);
  }
}