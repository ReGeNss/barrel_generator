import 'dart:typed_data';

import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart';
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Project generator service tests', () {
    test(
      "Creates a barrel for every folder returned by the repository",
      () async {
        final barrelGen = BarrelGeneratorServiceSpy();
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryFake([
            Folder('root'),
            Folder('root/a'),
            Folder('root/b'),
          ]),
          barrelGen: barrelGen,
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
      "Does nothing when the repository returns no folders",
      () async {
        final barrelGen = BarrelGeneratorServiceSpy();
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryFake([]),
          barrelGen: barrelGen,
        );

        await service.generateBarrelsFrom(Folder('root'));

        expect(barrelGen.calls, isEmpty);
      },
    );

    test(
      "Passes the requested folder on to the repository",
      () async {
        final repo = ProjectGenerateRepositoryFake([Folder('root')]);
        final service = ProjectGeneratorService(
          repo: repo,
          barrelGen: BarrelGeneratorServiceSpy(),
        );
        final root = Folder('root');

        await service.generateBarrelsFrom(root);

        expect(repo.lastRequestedFolder, same(root));
      },
    );

    test(
      "Generates barrels in the same order the repository returns them",
      () async {
        final barrelGen = BarrelGeneratorServiceSpy();
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryFake([
            Folder('root/b'),
            Folder('root/a'),
            Folder('root'),
          ]),
          barrelGen: barrelGen,
        );

        await service.generateBarrelsFrom(Folder('root'));

        expect(barrelGen.calls.map((folder) => folder.path), [
          'root/b',
          'root/a',
          'root',
        ]);
      },
    );
  });

  group('Project generator service tests with files in the tree', () {
    test(
      "Includes files from a folder in its generated barrel",
      () async {
        final fs = InMemoryGeneratorRepository(
          existingPaths: {'root', 'root/a', 'root/a/b'},
          folderEntries: {
            'root': {Folder('root/a')},
            'root/a': {
              FsFile('root/a/foo.dart'),
              FsFile('root/a/bar.dart'),
              Folder('root/a/b'),
            },
            'root/a/b': {},
          },
        );
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryFake([
            Folder('root'),
            Folder('root/a'),
            Folder('root/a/b'),
          ]),
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
      },
    );

    test(
      "Excludes files ignored by the ignore repository from the barrel",
      () async {
        final fs = InMemoryGeneratorRepository(
          existingPaths: {'root', 'root/a', 'root/a/b'},
          folderEntries: {
            'root': {Folder('root/a')},
            'root/a': {
              FsFile('root/a/foo.dart'),
              FsFile('root/a/foo.g.dart'),
              Folder('root/a/b'),
            },
            'root/a/b': {},
          },
        );
        final service = ProjectGeneratorService(
          repo: ProjectGenerateRepositoryFake([
            Folder('root'),
            Folder('root/a'),
            Folder('root/a/b'),
          ]),
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

class ProjectGenerateRepositoryFake implements ProjectGenerateRepository {
  final List<Folder> tree;
  Folder? lastRequestedFolder;

  ProjectGenerateRepositoryFake(this.tree);

  @override
  Future<List<Folder>> getFlatTree(Folder folder) async {
    lastRequestedFolder = folder;
    return tree;
  }
}

class BarrelGeneratorServiceSpy extends BarrelGeneratorService {
  final List<Folder> calls = [];

  BarrelGeneratorServiceSpy()
      : super(repo: GeneratorRepositoryImpl(), ignoreRepo: NoopPathToIgnoreRepository());

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

class InMemoryGeneratorRepository extends GeneratorRepositoryImpl {
  final Set<String> existingPaths;
  final Map<String, Set<FsEntity>> folderEntries;
  final Map<String, Uint8List> _files = {};

  InMemoryGeneratorRepository({
    required this.existingPaths,
    required this.folderEntries,
  });

  String contentsOf(String path) => String.fromCharCodes(_files[path] ?? Uint8List(0));

  @override
  Future<bool> exists(FsEntity path) async {
    return existingPaths.contains(path.path) || _files.containsKey(path.path);
  }

  @override
  Future<void> create(FsFile path) async {
    _files.putIfAbsent(path.path, () => Uint8List(0));
  }

  @override
  Future<Uint8List> read(FsFile path) async {
    return _files[path.path] ?? Uint8List(0);
  }

  @override
  Future<void> write(FsFile path, Uint8List data) async {
    _files[path.path] = data;
  }

  @override
  Future<void> appendToFile(FsFile path, Uint8List data) async {
    final existing = _files[path.path] ?? Uint8List(0);
    _files[path.path] = Uint8List.fromList([...existing, ...data]);
  }

  @override
  Future<List<String>> readAsLines(FsFile path) async {
    final content = _files[path.path];
    if (content == null) {
      return [];
    }
    return String.fromCharCodes(content)
        .split('\n')
        .where((line) => line.isNotEmpty)
        .toList();
  }

  @override
  Future<Set<FsEntity>> listFolderEntry(Folder path) async {
    return folderEntries[path.path] ?? {};
  }

  @override
  Future<void> renameFile(FsFile file, FsFile newFile) async {
    final content = _files.remove(file.path);
    if (content != null) {
      _files[newFile.path] = content;
    }
  }
}
