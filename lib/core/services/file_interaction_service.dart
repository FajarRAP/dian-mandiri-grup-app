import 'dart:io';

import 'package:file_selector/file_selector.dart' as fs;
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../../common/constants/app_enums.dart';

abstract interface class FileInteractionService {
  /// [extensions] is optional, default to ['csv', 'xls', 'xlsx']
  Future<File?> pickFile([List<String> extensions]);
  Future<OpenFileStatus> openFile(String path);
  Future<ShareFileStatus> shareFiles(List<String> paths);
}

class FileInteractionServiceImpl implements FileInteractionService {
  const FileInteractionServiceImpl({required this.sharePlus});

  final SharePlus sharePlus;

  @override
  Future<File?> pickFile([
    List<String> extensions = const ['csv', 'xls', 'xlsx'],
  ]) async {
    final typeGroup = fs.XTypeGroup(label: 'documents', extensions: extensions);
    final file = await fs.openFile(acceptedTypeGroups: [typeGroup]);

    if (file == null) return null;

    return File(file.path);
  }

  @override
  Future<OpenFileStatus> openFile(String path) async {
    final result = await OpenFilex.open(path);

    return switch (result.type) {
      .done => .success,
      .noAppToOpen => .noAppToOpen,
      .fileNotFound => .failure,
      .permissionDenied => .failure,
      .error => .failure,
    };
  }

  @override
  Future<ShareFileStatus> shareFiles(List<String> paths) async {
    final shareParams = ShareParams(
      files: paths.map((path) => XFile(path)).toList(),
    );
    final result = await sharePlus.share(shareParams);

    return switch (result.status) {
      .success => .success,
      .dismissed => .cancelled,
      .unavailable => .failure,
    };
  }
}
