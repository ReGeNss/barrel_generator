abstract class FsEntity {
  final String path;
  final Folder? parentFolder;

  FsEntity(this.path, {Folder? parentFolder}) : parentFolder = parentFolder ?? _findParentFolder(path);

  static Folder? _findParentFolder(String path) {
    final folderPath = generateCrossPlatformRegExp(
      r'[\w\W]*[\/\\][\w\W]*(?![\w\.]*$)',
    ).stringMatch(path);

    return folderPath != null && folderPath.isNotEmpty
        ? Folder(folderPath)
        : null;
  }

  static final reg = RegExp(r'[\/\\]\w+\.\w+');

  factory FsEntity.fromPath(final String path) {
    if (reg.hasMatch(path)) {
      return FsFile(path);
    }
    return Folder(path);
  }

  String get name => generateCrossPlatformRegExp(
    r'([^\/\\]+?)(?:\.[^.\/\\]+)?$',
  ).firstMatch(path)!.group(1)!; // TODO:

  String get nameWithType => '$name.dart';

  FsEntity rename(String newName) {
    for (int i = path.length; i >= 0; i--) {
      final cut = path.substring(i - name.length, i);

      if (cut == name) {
        return FsEntity.fromPath(path.replaceRange(i - name.length, i, newName));
      }
    }
    throw ArgumentError('rename is failed');
  }
}

class FsFile extends FsEntity {
  FsFile(super.path, {super.parentFolder});

  // FolderPath get fileFolder {
  //   final folderPath = generateCrossPlatformRegExp(r'[\w\W]*(?=(\\|\/)[\w\W]*\.)').stringMatch(path);

  //   return FolderPath(folderPath!); // TODO
  // }

  String? get folderName => parentFolder?.name;
}

class Folder extends FsEntity {
  Folder(super.path, {super.parentFolder});

  // FolderPath get rootFolder => FolderPath( generateCrossPlatformRegExp(r'[\w\W]*[\/\][\w\W]*(?![\w\.]*$)').stringMatch(path)!);
}

RegExp generateCrossPlatformRegExp(String exp) {
  return RegExp(exp, caseSensitive: false);
}
