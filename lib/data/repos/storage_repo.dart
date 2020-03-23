import 'dart:io';

import 'package:xchat/data/providers/storage_provider.dart';

class StorageRepository{
  StorageProvider storageProvider = StorageProvider();
  Future<String> uploadImage(File file, String path) => storageProvider.uploadImage(file, path);
}