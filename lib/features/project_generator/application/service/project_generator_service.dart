import 'package:injectable/injectable.dart';
import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart';

@injectable
class ProjectGeneratorService {
  final ProjectGenerateRepository _repo;
  final BarrelGeneratorService _barrelGen;

  ProjectGeneratorService({
    required this._repo,
    required this._barrelGen,
  });

  Future<void> generateBarrelsFrom(Folder folder) async {
    final flatTree = await _repo.getFlatTree(folder);

    for (final folder in flatTree.whereType<Folder>()) {
      await _barrelGen.createForFolder(folder);
    }
    for (final file in flatTree.whereType<FsFile>()) {
      await _barrelGen.createForFile(file);
    }
  }
}
