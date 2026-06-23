import 'package:barrel_generator/data/repository/path_to_ignore_repository.dart';
import 'package:test/test.dart';

import '../source/path_to_ignore_source.dart';

void main() {
  group('Path to ignore repository tests', () {
    final repo = PathToIgnoreRepositoryImpl(workingDirectory: 'lib', source: PathToIgnoreSourceMock());

    setUp(() async {
      await repo.getPathsToIgnore();
    });

    test(
      "Ignore non workdir paths",
      () {
        final path = PathToIgnoreSourceFixtures.nonLibAbsolutePath;

        expect(repo.isIgnored(path), isTrue);
      },
    );
    
    test(
      "Ignore lib absolute path",
      () {
        final path = 'lib/dart';

        expect(repo.isIgnored(path), isTrue);
      },
    );

    test(
      "Ignore 2 stars",
      () {
        final path = "lib/test/path/${PathToIgnoreSourceFixtures.twoStarsPath}";

        expect(repo.isIgnored(path), isTrue);
      },
    );

    test(
      "Ignore path with one star",
      () {
        final path = PathToIgnoreSourceFixtures.oneStarPath.replaceAll("*", 'test');

        expect(repo.isIgnored(path), isTrue);
      },
    );

    test(
      "Ignore two non lib stars",
      () {
        final path = 'android/app/**.dart';

        expect(repo.isIgnored(path), isTrue);
      },
    );
  });
}