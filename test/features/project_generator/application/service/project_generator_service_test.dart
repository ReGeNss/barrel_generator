import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart';
import 'package:barrel_generator/features/project_generator/data/repository/project_generate_repository_impl.dart';
import 'package:test/test.dart';

import '../../data/sources/project_generate_source.dart';
import '../../domain/repository/generator_repository.dart';

void main() {
  group('Project generator service tests', () {
    test(
      "Creates a barrel for every folder returned by the repository",
      () async {
        final barrelGen = BarrelGeneratorServiceSpy();
        final service = ProjectGeneratorService(
          barrelGen: barrelGen,
          repo: ProjectGenerateRepositoryImpl(
            sources: ProjectGenerateSourceMock({'a': {}, 'b': {}}),
          ),
        );

        await service.generateBarrelsFrom(Folder('root'));

        expect(barrelGen.calls.map((folder) => folder.path), [
          'root',
          'root/a',
          'root/b',
        ]);
      },
    );
    test(
      "Generates barrels in the same order the repository returns them",
      () async {
        final barrelGen = BarrelGeneratorServiceSpy();
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryImpl(
            sources: ProjectGenerateSourceMock({'a': {}, 'b': {}}),
          ),
          barrelGen: barrelGen,
        );

        await service.generateBarrelsFrom(Folder('root'));

        expect(barrelGen.calls.map((folder) => folder.path), containsAll([
          'root',
          'root/a',
          'root/b',
        ]));
      },
    );
  });

  group('Project generator service tests with files in the tree', () {
    test("Includes files from a folder in its generated barrel", () async {
      final fs = InMemoryGeneratorRepository(
        tree: {
          'a': {
            'foo.dart': '',
            'bar.dart': '',
            'b': {'c.dart': ''},
          },
        },
      );
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock({
            'a': {
              'foo.dart': '',
              'bar.dart': '',
              'b': {'c.dart': ''},
            },
          }),
        ),
        barrelGen: BarrelGeneratorService(
          repo: fs,
          ignoreRepo: NoopPathToIgnoreRepository(),
        ),
      );

      await service.generateBarrelsFrom(Folder('root'));

      final barrel = fs.contentsOf('root/a/a.dart');
      expect(barrel, contains("export 'foo.dart';"));
      expect(barrel, contains("export 'bar.dart';"));
      expect(barrel, contains("export 'b/b.dart';"));
      expect(fs.existsByString('root/a/b/b.dart'), isTrue);
      final bBarrel = fs.contentsOf('root/a/b/b.dart');
      expect(bBarrel, contains("export 'c.dart';"));
      expect(bBarrel, isNot(contains("export 'b/b.dart';")));
    });

    test(
      "Excludes files ignored by the ignore repository from the barrel",
      () async {
        final fs = InMemoryGeneratorRepository(
          tree: {
            'a': {'foo.dart': '', 'foo.g.dart': '', 'b': {}},
          },
        );
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryImpl(
            sources: ProjectGenerateSourceMock({
              'a': {'foo.dart': '', 'foo.g.dart': '', 'b': {}},
            }),
          ),
          barrelGen: BarrelGeneratorService(
            repo: fs,
            ignoreRepo: IgnoreGeneratedFilesRepository(),
          ),
        );

        await service.generateBarrelsFrom(Folder('root'));

        final barrel = fs.contentsOf('root/a/a.dart');
        expect(barrel, contains("export 'foo.dart';"));
        expect(barrel, isNot(contains("export 'foo.g.dart';")));
      },
    );
  });
}

class BarrelGeneratorServiceSpy extends BarrelGeneratorService {
  final List<Folder> calls = [];

  BarrelGeneratorServiceSpy()
    : super(
        repo: GeneratorRepositoryImpl(),
        ignoreRepo: NoopPathToIgnoreRepository(),
      );

  @override
  Future<void> createForFolder(Folder path) async {
    calls.add(path);
  }
}

class NoopPathToIgnoreRepository implements PathToIgnoreRepository {
  @override
  bool isIgnored(String path) => false;
}

class IgnoreGeneratedFilesRepository implements PathToIgnoreRepository {
  @override
  bool isIgnored(String path) => path.endsWith('.g.dart');
}
