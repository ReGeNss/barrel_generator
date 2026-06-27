import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/path_to_ignore_repository.dart';
import 'package:barrel_generator/features/barrel_generator/data/source/path_to_ignore_source.dart';
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
        ]);
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

    test("Includes files fro", () async {
      final tree = {
        'core': {'constants.dart': ''},
        'features': {
          'auth': {
            'domain': {
              'entity': {'user.dart': ''},
              'repository': {'auth_repository.dart': ''},
            },
          },
        },
        'utils': {'extension': ''},
      };
      final fs = InMemoryGeneratorRepository(tree: tree);
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock(tree),
        ),
        barrelGen: BarrelGeneratorService(
          repo: fs,
          ignoreRepo: NoopPathToIgnoreRepository(),
        ),
      );

      await service.generateBarrelsFrom(Folder('root'));

      expect(fs.existsByString('root/core/core.dart'), isTrue);
      expect(
        fs.contentsOf('root/core/core.dart'),
        ContainsOnly([exportFile('constants')]),
      );

      expect(
        fs.contentsOf('root/features/auth/domain/entity/entity.dart'),
        ContainsOnly([exportFile('user')]),
      );

      expect(
        fs.contentsOf('root/features/auth/domain/domain.dart'),
        containsAll([exportFolder('entity'), exportFolder('repository'), '']),
      );
    });

    test("Ignore files from git ignore", () async {
      final tree = {
        'config': {
          'di': {'injectable.dart': "", 'injectable.config.dart': ""},
        },
        'core': {'constants.dart': ''},
        'features': {
          'auth': {
            'domain': {
              'entity': {'user.dart': '', 'user.g.dart': ''},
              'repository': {'auth_repository.dart': '', 'some.dart': ''},
            },
          },
        },
        'utils': {'extension': ''},
      };

      final src = PathToIgnoreSourceMock(
        ignore: ['**.g.dart', '**/some.dart', '**/injectable.config.dart'],
      );

      final ign = PathsToIgnoreRepositoryImpl(
        source: src,
        workingDirectory: 'root',
      );

      await ign.getPathsToIgnore();

      final fs = InMemoryGeneratorRepository(tree: tree);
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock(tree),
        ),
        barrelGen: BarrelGeneratorService(repo: fs, ignoreRepo: ign),
      );

      await service.generateBarrelsFrom(Folder('root'));

      expect(
        fs.contentsOf('root/features/auth/domain/entity/entity.dart'),
        isNot(containsAll([exportFile('user.g')])),
      );

      expect(
        fs.contentsOf('root/config/di/di.dart'),
        isNot(containsAll([exportFile('injectable.config')])),
      );

      expect(
        fs.contentsOf('root/features/auth/domain/repository/repository.dart'),
        isNot(containsOnce(exportFile('some'))),
      );
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

    test("Project generation is idempotent", () async {
      var tree = {
        'a': {'foo.dart': '', 'foo.g.dart': ''},
      };
      final fs = InMemoryGeneratorRepository(tree: tree);
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock(tree),
        ),
        barrelGen: BarrelGeneratorService(
          repo: fs,
          ignoreRepo: IgnoreGeneratedFilesRepository(),
        ),
      );

      await service.generateBarrelsFrom(Folder('root'));

      final barrel1 = fs.contentsOf('root/a/a.dart');
      expect(barrel1, containsOnce("export 'foo.dart';"));
      expect(barrel1, isNot(contains("export 'foo.g.dart';")));

      await service.generateBarrelsFrom(Folder('root'));

      final barrel2 = fs.contentsOf('root/a/a.dart');

      expect(barrel2, containsOnce("export 'foo.dart';"));
      expect(barrel2, isNot(contains("export 'foo.g.dart';")));
    });

    test("Idempotent if baller already exists and writes EOF", () async {
      var tree = {
        'a': {'foo.dart': '', 'foo.g.dart': '', 'a.dart': exportFile('foo')},
      };
      final fs = InMemoryGeneratorRepository(tree: tree);
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock(tree),
        ),
        barrelGen: BarrelGeneratorService(
          repo: fs,
          ignoreRepo: IgnoreGeneratedFilesRepository(),
        ),
      );

      await service.generateBarrelsFrom(Folder('root'));

      final barrel1 = fs.contentsOf('root/a/a.dart');
      expect(barrel1, containsAllInOrder([exportFile('foo'), '']));
      expect(barrel1, isNot(contains("export 'foo.g.dart';")));
    });

    test("don't add EOF if already exists", () async {
      var tree = {
        'a': {'foo.dart': '', 'foo.g.dart': '', 'a.dart': exportFile('foo')},
      };
      final fs = InMemoryGeneratorRepository(tree: tree);
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock(tree),
        ),
        barrelGen: BarrelGeneratorService(
          repo: fs,
          ignoreRepo: IgnoreGeneratedFilesRepository(),
        ),
      );

      await service.generateBarrelsFrom(Folder('root'));
      await service.generateBarrelsFrom(Folder('root'));

      final barrel1 = fs.contentsOf('root/a/a.dart');
      expect(barrel1.length, 2);
      expect(barrel1, containsAllInOrder([exportFile('foo'), '']));
      expect(barrel1, isNot(contains("export 'foo.g.dart';")));
    });

    test(
      "Idempotent if baller already exists and not writes EOF if it exists",
      () async {
        var tree = {
          'a': {
            'foo.dart': '',
            'foo.g.dart': '',
            'a.dart': '${exportFile('foo')}\n',
          },
        };
        final fs = InMemoryGeneratorRepository(tree: tree);
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryImpl(
            sources: ProjectGenerateSourceMock(tree),
          ),
          barrelGen: BarrelGeneratorService(
            repo: fs,
            ignoreRepo: IgnoreGeneratedFilesRepository(),
          ),
        );

        await service.generateBarrelsFrom(Folder('root'));

        final barrel1 = fs.contentsOf('root/a/a.dart');
        expect(barrel1, containsAllInOrder([exportFile('foo'), '']));
        expect(barrel1, isNot(contains("export 'foo.g.dart';")));
      },
    );

    test(
      "Idempotent if baller already exists and not writes EOF if it exists",
      () async {
        var tree = {
          'a': {
            'foo.dart': '',
            'foo.g.dart': '',
            'a.dart': '${exportFile('foo')}\n',
          },
        };
        final fs = InMemoryGeneratorRepository(tree: tree);
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryImpl(
            sources: ProjectGenerateSourceMock(tree),
          ),
          barrelGen: BarrelGeneratorService(
            repo: fs,
            ignoreRepo: IgnoreGeneratedFilesRepository(),
          ),
        );

        await service.generateBarrelsFrom(Folder('root'));

        final barrel1 = fs.contentsOf('root/a/a.dart');
        expect(barrel1, containsAllInOrder([exportFile('foo'), '']));
        expect(barrel1, isNot(contains("export 'foo.g.dart';")));
      },
    );

    test("throws error when barrel contains something else", () async {
      var tree = {
        'a': {
          'foo.dart': '',
          'foo.g.dart': '',
          'a.dart': '${exportFile('foo2')}\n ${exportFile('file')}\n fasdfas\n',
        },
      };
      final fs = InMemoryGeneratorRepository(tree: tree);
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock(tree),
        ),
        barrelGen: BarrelGeneratorService(
          repo: fs,
          ignoreRepo: IgnoreGeneratedFilesRepository(),
        ),
      );

      await expectLater(
        () async => await service.generateBarrelsFrom(Folder('root')),
        throwsA(isA<ArgumentError>()),
      );
    });
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

String exportFile(String name) {
  return "export '$name.dart';";
}

String exportFolder(String name) {
  return "export '$name/$name.dart';";
}

class ContainsOnly extends Matcher {
  final List<String> content;

  ContainsOnly(this.content) {
    content.add('');
  }

  @override
  Description describe(Description description) {
    return description..add(content.toString());
  }

  @override
  bool matches(item, Map<dynamic, dynamic> matchState) {
    if (item is! List<String>) {
      throw ArgumentError.value(item, 'item', 'should be List<String>');
    }

    if (item.indexed.every((pair) => content[pair.$1] == pair.$2)) return true;

    return false;
  }
}

class PathToIgnoreSourceMock implements PathToIgnoreSource {
  final List<String> ignore;

  PathToIgnoreSourceMock({required this.ignore});
  @override
  Future<List<String>> getGitIgnore() async {
    return ignore;
  }
}
