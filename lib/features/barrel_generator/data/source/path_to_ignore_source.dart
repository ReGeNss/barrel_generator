import 'dart:io';

import 'package:injectable/injectable.dart';

@singleton
class PathToIgnoreSource {
  Future<List<String>> getGitIgnore() async {
    final gitignore = await Process.run(Platform.isWindows ? 'type' : 'cat', [
      '.gitignore',
    ], runInShell: true);

    final barrelIgnore = await Process.run(Platform.isWindows ? 'type' : 'cat', [
      '.barrel_ignore',
    ], runInShell: true);

    try {
      final gitIgnoreLines = gitignore.stdout as String;
      final barrelIgnoreLines = barrelIgnore.stdout as String;

      return [...gitIgnoreLines.split('\n'), ...barrelIgnoreLines.split('\n')] ;
    } catch (e) {
      return [];
    }
  }
}