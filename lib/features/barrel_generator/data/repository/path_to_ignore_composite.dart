import 'package:barrel_generator/config/config.dart';
import 'package:injectable/injectable.dart';
import 'package:barrel_generator/features/features.dart';

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