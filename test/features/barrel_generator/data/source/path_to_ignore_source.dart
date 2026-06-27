import 'package:barrel_generator/features/barrel_generator/data/source/path_to_ignore_source.dart';

class PathToIgnoreSourceMock implements PathToIgnoreSource {
  @override
  Future<List<String>> getGitIgnore() async {
    return pathToIgnoreFixture();
  }
}

List<String> pathToIgnoreFixture() {
  return [
      PathToIgnoreSourceFixtures.libAbsolutePath,
      PathToIgnoreSourceFixtures.nonLibAbsolutePath,
      PathToIgnoreSourceFixtures.commentedPath,
      PathToIgnoreSourceFixtures.twoStarsPath,
      PathToIgnoreSourceFixtures.oneStarPath,
      PathToIgnoreSourceFixtures.twoStarsLinux,
    ];
}

class PathToIgnoreSourceFixtures {
 static const libAbsolutePath = "lib/main.dart";
 static const nonLibAbsolutePath = 'android/app/json.dart';
 static const commentedPath = '#lib/main2.dart';
 static const twoStarsPath  = '**.g.dart';
 static const oneStarPath = 'repository/*/sources';
 static const twoNonLibStars = 'android/app/**.dart';
 static const twoStarsLinux = r'**/injectable.config.dart';
 static const twoStarsWindows = r'lib\config\injectable.config.dart';
}
