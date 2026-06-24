import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/data/sources/project_generate_source.dart';

class ProjectGenerateSourceMock implements ProjectGenerateSource {
  final Map<String, List<String>> tree;

  ProjectGenerateSourceMock(this.tree);

  @override
  Future<List<Folder>> listDirsInDir(Folder folder) async {
    return (tree[folder.path] ?? []).map((path) => Folder(path)).toList();
  }
}
