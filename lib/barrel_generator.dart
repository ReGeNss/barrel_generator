import 'package:args/args.dart';
import 'package:barrel_generator/config/di/injectable.dart';
import 'package:barrel_generator/features/barrel_generator/application/service/watch_barrel_generator.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart';

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
  await configureDependencies();
  final ArgParser argParser = buildParser();

  try {
    final ArgResults results = argParser.parse(arguments);

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
      await (await sl.getAsync<WatchBarrelGeneratorService>()).watch();
      return;
    }

    await (await sl.getAsync<ProjectGeneratorService>()).generateBarrelsFrom(Folder('lib'));

  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
