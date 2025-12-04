import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract interface class FileService {
  Future<bool> isFileExist(String filename);
  Future<String> getFullPath(String filename);
}

class FileServiceImpl implements FileService {
  const FileServiceImpl();

  Future<String> _getExternalPath() async {
    final dir = await getExternalStorageDirectory();

    return '${dir?.path}';
  }

  @override
  Future<bool> isFileExist(String filename) async {
    final externalPath = await _getExternalPath();
    final filePath = '$externalPath/$filename';
    final file = File(filePath);

    return await file.exists();
  }

  @override
  Future<String> getFullPath(String filename) async {
    final externalPath = await _getExternalPath();

    return '$externalPath/$filename';
  }
}
