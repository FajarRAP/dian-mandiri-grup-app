import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileService {
  const FileService();

  Future<String> _getExternalPath() async {
    final dir = await getExternalStorageDirectory();

    return '${dir?.path}';
  }

  Future<bool> isFileExist(String filename) async {
    final externalPath = await _getExternalPath();
    final filePath = '$externalPath/$filename';
    final file = File(filePath);

    return await file.exists();
  }

  Future<String> getFullPath(String filename) async {
    final externalPath = await _getExternalPath();

    return '$externalPath/$filename';
  }
}
