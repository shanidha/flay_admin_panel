import '../entities/media_entity.dart';
import '../repositories/media_repository.dart';

class FetchMediaByFolder {
  final MediaRepository repository;

  FetchMediaByFolder(this.repository);

  Future<List<MediaEntity>> call(String folder, {int limit = 20}) {
    return repository.fetchMediaByFolder(folder, limit: limit);
  }
}