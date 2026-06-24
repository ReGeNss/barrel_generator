class FsTree {

}

abstract class FsObject {
  final String path;

  FsObject({required this.path});
}

class FsFile extends FsObject {
  FsFile({required super.path});

}

class FsFolder extends FsObject {
  FsFolder({required super.path});
}