import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/media_model.dart';

abstract class MediaRemoteDataSource {
  Future<List<MediaModel>> fetchMediaByFolder(String folder, {int limit = 20});
  Future<String> createMediaDocument(MediaModel media);
  Future<void> deleteMediaDocument(String id);
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final FirebaseFirestore firestore;

  MediaRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _mediaCollection =>
      firestore.collection('media');

  @override
  Future<List<MediaModel>> fetchMediaByFolder(String folder,
      {int limit = 20}) async {
    final snapshot = await _mediaCollection
        .where('folder', isEqualTo: folder)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => MediaModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<String> createMediaDocument(MediaModel media) async {
    final docRef = await _mediaCollection.add(media.toMap());
    return docRef.id;
  }

  @override
  Future<void> deleteMediaDocument(String id) async {
    await _mediaCollection.doc(id).delete();
  }
}