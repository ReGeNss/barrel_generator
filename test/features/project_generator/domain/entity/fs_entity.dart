abstract class MFsEntity {
  final String route;
  final String path;

  MFsEntity(this.route, this.path);
}

class MFile extends MFsEntity {
  String content;

  MFile(super.route, super.path, {this.content = ''});

  @override
  String toString() {
    return 'file: $path';
  }
}

class MFolder extends MFsEntity {
  final List<MFsEntity> entries;

  MFolder(super.route, super.path, {required this.entries});

  factory MFolder.generate(Map<String, dynamic> tree) {
    MFolder getFolder(Map<String, dynamic> tree, String path) {
      final folderE = <MFsEntity>[];
      for (final entry in tree.entries) {
        final curPath = '$path/${entry.key}';

        if (entry.value is Map<String, dynamic>) {
          folderE.add(getFolder(entry.value, curPath));
        } else if (entry.value is Map<dynamic, dynamic>) {
          folderE.add(MFolder(entry.key, curPath, entries: []));
        } else {
          folderE.add(MFile(entry.key, curPath, content: entry.value));
        }
      }
      return MFolder(path.split('/').last, path, entries: folderE);
    }

    return getFolder(tree, 'root');
  }

  @override
  String toString() {
    return 'folder: $path\n ${entries.join('\n')}';
  }
}
