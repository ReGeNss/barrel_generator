import 'package:barrel_generator/core/core.dart';
import 'package:barrel_generator/features/features.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProjectGeneratorService {
  final ProjectGenerateRepository _repo;
  final BarrelGeneratorService _barrelGen;
  final String workDir;

  ProjectGeneratorService({
    required this._repo,
    required this._barrelGen, 
    @Named(wokDirName) required this.workDir,
  });

  Future<void> generateBarrels() async {
    final flatTree = await _repo.getFlatTree(Folder(workDir));

    for (final folder in flatTree.whereType<Folder>()) {
      await _barrelGen.createForFolder(folder);
    }
    for (final file in flatTree.whereType<FsFile>()) {
      await _barrelGen.createForFile(file);
    }
  }
}
