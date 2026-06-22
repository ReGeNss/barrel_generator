import 'package:args/args.dart';
import 'package:barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/application/service/fs_watcher.dart';
import 'package:barrel_generator/domain/generator_repository.dart';

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
    ..addCommand('watch')
    ;
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
      await FsWatcher(generator: BarrelGeneratorService()).watch();
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
