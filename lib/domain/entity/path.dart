abstract class Path {
  final String path;
  final FolderPath parentFolder;

  Path(this.path)
    : parentFolder = FolderPath(
        generateCrossPlatformRegExp(
          r'[\w\W]*[\/\][\w\W]*(?![\w\.]*$)',
        ).stringMatch(path)!,
      );

  String get name => generateCrossPlatformRegExp(
    r'([^\/\\]+?)(?:\.[^.\/\\]+)?$',
  ).firstMatch(path)!.group(1)!; // TODO:

  String get nameWithType => '$name.dart';
}

class FilePath extends Path {
  FilePath(super.path);

  // FolderPath get fileFolder {
  //   final folderPath = generateCrossPlatformRegExp(r'[\w\W]*(?=(\\|\/)[\w\W]*\.)').stringMatch(path);

  //   return FolderPath(folderPath!); // TODO
  // }

  String get folderName => parentFolder.name;
}

class FolderPath extends Path {
  FolderPath(super.path);

  // FolderPath get rootFolder => FolderPath( generateCrossPlatformRegExp(r'[\w\W]*[\/\][\w\W]*(?![\w\.]*$)').stringMatch(path)!);
}

RegExp generateCrossPlatformRegExp(String exp) {
  return RegExp(exp, caseSensitive: false);
}
