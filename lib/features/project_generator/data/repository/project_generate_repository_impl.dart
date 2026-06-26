import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/data/sources/project_generate_source.dart';
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ProjectGenerateRepository)
class ProjectGenerateRepositoryImpl implements ProjectGenerateRepository {
  final ProjectGenerateSource sources;

  ProjectGenerateRepositoryImpl({required this.sources});

  @override
  Future<List<FsEntity>> getFlatTree(Folder folder) async {
    return await get(folder, true);
  }

  Future<List<FsEntity>> get(Folder folder, bool selfExport) async {
    final result = <FsEntity>[if(selfExport) folder];
    final dirEntry = await sources.listDirEntry(folder);
    final dirFolders = dirEntry.whereType<Folder>();

    if (dirFolders.isEmpty) {
      return [...result, ?dirEntry.whereType<FsFile>().firstOrNull];
    }

    for (final (i, entry) in dirFolders.indexed) {
      result.addAll(await get(entry, i == 0));
    }
    return [...result];
  }
}