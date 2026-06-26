import 'package:barrel_generator/config/di/injectable.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/non_barrel_path_repository.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/path_to_ignore_repository.dart';
import 'package:barrel_generator/features/barrel_generator/data/source/path_to_ignore_source.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: PathToIgnoreRepository)
class PathToIgnoreComposite implements PathToIgnoreRepository {
  final List<PathToIgnoreRepository> _parts;

  PathToIgnoreComposite({required this._parts});

  @override
  bool isIgnored(String path) {
    for (final part in _parts) {
      if (part.isIgnored(path)) {
        return true;
      }
    }
    return false;
  }
}

@module
abstract class PathToIgnoreModule {
  @singleton
  Future<List<PathToIgnoreRepository>> ignoreRepos(PathToIgnoreSource source) async => [
    await sl.getAsync<PathsToIgnoreRepositoryImpl>(),
    sl.get<NonBarrelPathRepository>(),
  ];
}