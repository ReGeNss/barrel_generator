// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart'
    as _i398;
import 'package:barrel_generator/features/barrel_generator/application/service/watch_barrel_generator.dart'
    as _i761;
import 'package:barrel_generator/features/barrel_generator/data/repository/generator_repository_impl.dart'
    as _i858;
import 'package:barrel_generator/features/barrel_generator/data/repository/non_barrel_path_repository.dart'
    as _i1039;
import 'package:barrel_generator/features/barrel_generator/data/repository/path_to_ignore_composite.dart'
    as _i69;
import 'package:barrel_generator/features/barrel_generator/data/repository/path_to_ignore_repository.dart'
    as _i166;
import 'package:barrel_generator/features/barrel_generator/data/repository/system_watcher.dart'
    as _i672;
import 'package:barrel_generator/features/barrel_generator/data/source/path_to_ignore_source.dart'
    as _i217;
import 'package:barrel_generator/features/barrel_generator/domain/repository/fs_watcher.dart'
    as _i665;
import 'package:barrel_generator/features/barrel_generator/domain/repository/generator_repository.dart'
    as _i627;
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart'
    as _i1023;
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart'
    as _i1056;
import 'package:barrel_generator/features/project_generator/data/repository/project_generate_repository_impl.dart'
    as _i856;
import 'package:barrel_generator/features/project_generator/data/sources/project_generate_source.dart'
    as _i527;
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart'
    as _i386;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final pathToIgnoreModule = _$PathToIgnoreModule();
    gh.singleton<_i217.PathToIgnoreSource>(() => _i217.PathToIgnoreSource());
    gh.singleton<_i527.ProjectGenerateSource>(
      () => _i527.ProjectGenerateSource(),
    );
    gh.factory<_i627.GeneratorRepository>(
      () => _i858.GeneratorRepositoryImpl(),
    );
    gh.singleton<_i1039.NonBarrelPathRepository>(
      () => _i1039.NonBarrelPathRepository(gh<String>(instanceName: 'wokDir')),
    );
    gh.singletonAsync<_i166.PathsToIgnoreRepositoryImpl>(() {
      final i = _i166.PathsToIgnoreRepositoryImpl(
        source: gh<_i217.PathToIgnoreSource>(),
        workingDirectory: gh<String>(instanceName: 'wokDir'),
      );
      return i.getPathsToIgnore().then((_) => i);
    });
    gh.singletonAsync<List<_i1023.PathToIgnoreRepository>>(
      () => pathToIgnoreModule.ignoreRepos(gh<_i217.PathToIgnoreSource>()),
    );
    gh.singletonAsync<_i1023.PathToIgnoreRepository>(
      () async => _i69.PathToIgnoreComposite(
        parts: await getAsync<List<_i1023.PathToIgnoreRepository>>(),
      ),
    );
    gh.singleton<_i386.ProjectGenerateRepository>(
      () => _i856.ProjectGenerateRepositoryImpl(
        sources: gh<_i527.ProjectGenerateSource>(),
      ),
    );
    gh.singletonAsync<_i665.FsWatcher>(
      () async => _i672.SystemWatcher(
        ignoredPaths: await getAsync<_i1023.PathToIgnoreRepository>(),
      ),
    );
    gh.factoryAsync<_i398.BarrelGeneratorService>(
      () async => _i398.BarrelGeneratorService(
        repo: gh<_i627.GeneratorRepository>(),
        ignoreRepo: await getAsync<_i1023.PathToIgnoreRepository>(),
      ),
    );
    gh.factoryAsync<_i1056.ProjectGeneratorService>(
      () async => _i1056.ProjectGeneratorService(
        repo: gh<_i386.ProjectGenerateRepository>(),
        barrelGen: await getAsync<_i398.BarrelGeneratorService>(),
        workDir: gh<String>(instanceName: 'wokDir'),
      ),
    );
    gh.factoryAsync<_i761.WatchBarrelGeneratorService>(
      () async => _i761.WatchBarrelGeneratorService(
        fsEvents: await getAsync<_i665.FsWatcher>(),
        g: await getAsync<_i398.BarrelGeneratorService>(),
      ),
    );
    return this;
  }
}

class _$PathToIgnoreModule extends _i69.PathToIgnoreModule {}
