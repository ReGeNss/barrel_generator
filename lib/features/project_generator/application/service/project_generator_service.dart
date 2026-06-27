import 'package:barrel_generator/core/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart';

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
