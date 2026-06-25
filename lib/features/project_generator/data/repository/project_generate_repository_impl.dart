import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/data/sources/project_generate_source.dart';
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProjectGenerateRepository)
class ProjectGenerateRepositoryImpl implements ProjectGenerateRepository {
  final ProjectGenerateSource sources;

  ProjectGenerateRepositoryImpl({required this.sources});

  @override
  Future<List<Folder>> getFlatTree(Folder folder) async {
    return await get(folder);
  }

  Future<List<Folder>> get(Folder folder) async {
    final result = <Folder>[folder];
    final dirEntry = await sources.listDirsInDir(folder);
    
    if (dirEntry.isEmpty) {
      return [...result];
    }

    for (final entry in dirEntry) {
      result.addAll(await get(entry));
    }
    return [...result];
  }
}