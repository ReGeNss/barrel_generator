import 'package:barrel_generator/core/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable.config.dart';

final sl = GetIt.instance;

@InjectableInit()  
Future<void> configureDependencies(String workDir) async {
  sl.registerSingleton(workDir, instanceName: wokDirName);

  await sl.init().allReady();
}