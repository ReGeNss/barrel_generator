import 'dart:io';

import 'package:args/args.dart';
import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/application/service/watch_barrel_generator.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/system_watcher.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/path_to_ignore_repository.dart';
import 'package:barrel_generator/features/barrel_generator/data/source/path_to_ignore_source.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart';
import 'package:barrel_generator/features/project_generator/data/repository/project_generate_repository_impl.dart';
import 'package:barrel_generator/features/project_generator/data/sources/project_generate_source.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.')
    ..addCommand('watch');
}

void printUsage(ArgParser argParser) {
  print('Usage: dart barrel_generator.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();

  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('barrel_generator version: $version');
      return;
    }

    if (results.command?.name == 'watch') {
      final ignore = PathToIgnoreRepositoryImpl(
        workingDirectory: 'lib',
        source: PathToIgnoreSource(),
      )..getPathsToIgnore();

      await WatchBarrelGeneratorService(
        fsEvents: SystemWatcher(ignoredPaths: ignore),
        g: BarrelGeneratorService(
          repo: GeneratorRepositoryImpl(),
          ignoreRepo: ignore,
        ),
      ).watch();
      return;
    }

    await ProjectGeneratorService(
      repo: ProjectGenerateRepositoryImpl(sources: ProjectGenerateSource()),
      barrelGen: BarrelGeneratorService(
        repo: GeneratorRepositoryImpl(),
        ignoreRepo: PathToIgnoreRepositoryImpl(
          workingDirectory: 'lib',
          source: PathToIgnoreSource(),
        )..getPathsToIgnore(),
      ),
    ).generateBarrelsFrom(Folder(Directory.current.path));
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
