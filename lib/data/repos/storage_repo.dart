import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:xchat/data/providers/storage_provider.dart';

class StorageRepository{
  StorageProvider storageProvider = StorageProvider(firebaseStorage: FirebaseStorage.instance);
  Future<String> uploadImage(File file, String path) => storageProvider.uploadImage(file, path);
}