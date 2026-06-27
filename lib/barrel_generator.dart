import 'package:args/command_runner.dart';
import 'package:barrel_generator/config/di/injectable.dart';
import 'package:barrel_generator/features/barrel_generator/application/service/watch_barrel_generator.dart';
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart';

const String version = '0.0.1';

void main(List<String> arguments) async {
  final runner = BarrelGeneratorRunner('barrel_generator', 'Generates barrels from selected dir by default - lib/');

  runner.argParser
    .addFlag('version', negatable: false, help: 'Print the tool version.');
  runner..addCommand(WatchCommand())..addCommand(GenerateCommand());
  
  try {
    final results = runner.parse(arguments);
    final workDir = results.rest.firstOrNull ?? 'lib';
    await configureDependencies(workDir);

    if (results.flag('version')) {
      print('barrel_generator version: $version');
      return;
    }

    await runner.runCommand(results);
  } on FormatException catch (e) {
    print(e.message);
    print('');
    runner.printUsage();
  }
}

class WatchCommand extends Command {
  @override
  String get description => 'watch selected dir recursively generates barrels for new files, folders, renames, deletions';

  @override
  String get name => 'watch';

  @override
  Future<void> run() async {
    await (await sl.getAsync<WatchBarrelGeneratorService>()).watch();
  }
}

class GenerateCommand extends Command {
  @override
  String get description => 'generate barrels from work dir';

  @override
  String get name => 'generate';

  @override
  Future<void> run() async {
    await (await sl.getAsync<ProjectGeneratorService>()).generateBarrels();
  }
}

class BarrelGeneratorRunner extends CommandRunner {
  BarrelGeneratorRunner(super.executableName, super.description);

  @override
  String get invocation => 'barrel_generator <command> <path>';
}
