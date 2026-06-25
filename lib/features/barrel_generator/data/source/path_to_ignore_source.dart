import 'dart:io';

import 'package:injectable/injectable.dart';

@singleton
class PathToIgnoreSource {
  Future<List<String>> getGitIgnore() async {
    final process = await Process.run(Platform.isWindows ? 'type' : 'cat', [
      '.gitignore',
    ], runInShell: true);

    try {
      final result = process.stdout as String;

      return result.split('\n');
    } catch (e) {
      return [];
    }
  }
}