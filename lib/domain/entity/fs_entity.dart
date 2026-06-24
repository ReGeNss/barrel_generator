abstract class FsEntity {
  final String path;
  final Folder? parentFolder;

  FsEntity(this.path) : parentFolder = _findParentFolder(path);

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
}

class FsFile extends FsEntity {
  FsFile(super.path);

  // FolderPath get fileFolder {
  //   final folderPath = generateCrossPlatformRegExp(r'[\w\W]*(?=(\\|\/)[\w\W]*\.)').stringMatch(path);

  //   return FolderPath(folderPath!); // TODO
  // }

  String? get folderName => parentFolder?.name;
}

class Folder extends FsEntity {
  Folder(super.path);

  // FolderPath get rootFolder => FolderPath( generateCrossPlatformRegExp(r'[\w\W]*[\/\][\w\W]*(?![\w\.]*$)').stringMatch(path)!);
}

RegExp generateCrossPlatformRegExp(String exp) {
  return RegExp(exp, caseSensitive: false);
}
