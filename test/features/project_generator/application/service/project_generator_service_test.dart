import 'dart:typed_data';

import 'package:barrel_generator/features/barrel_generator/application/service/barrel_generator_service.dart';
import 'package:barrel_generator/features/barrel_generator/data/repository/generator_repository_impl.dart';
import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/generator_repository.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:barrel_generator/features/project_generator/application/service/project_generator_service.dart';
import 'package:barrel_generator/features/project_generator/domain/repository/project_generate_repository.dart';
import 'package:injectable_generator/utils.dart';
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

    test("Does nothing when the repository returns no folders", () async {
      final barrelGen = BarrelGeneratorServiceSpy();
      final service = ProjectGeneratorService(
        repo: ProjectGenerateRepositoryFake([]),
        barrelGen: barrelGen,
      );

      await service.generateBarrelsFrom(Folder('root'));

      expect(barrelGen.calls, isEmpty);
    });

    test("Passes the requested folder on to the repository", () async {
      final repo = ProjectGenerateRepositoryFake([Folder('root')]);
      final service = ProjectGeneratorService(
        repo: repo,
        barrelGen: BarrelGeneratorServiceSpy(),
      );
      final root = Folder('root');

      await service.generateBarrelsFrom(root);

      expect(repo.lastRequestedFolder, same(root));
    });

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
    test("Includes files from a folder in its generated barrel", () async {
      final fs = InMemoryGeneratorRepository(
        tree: {
          'a': {'foo.dart': '', 'bar.dart': '', 'b': {}},
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
      expect(fs.existsByString('root/a/b/b.dart'), isTrue);
      expect(fs.contentsOf('root/a/b/b.dart'), '');
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

abstract class MFsEntity {
  final String route;
  final String path;

  MFsEntity(this.route, this.path);
}

class MFile extends MFsEntity {
  final String content;

  MFile(super.route, super.path, {this.content = ''});

  @override
  String toString() {
    return 'file: $path';
  }
}

class MFolder extends MFsEntity {
  final List<MFsEntity> entries;

  MFolder(super.route, super.path, {required this.entries});

  factory MFolder.generate(Map<String, dynamic> tree) {
    MFolder getFolder(Map<String, dynamic> tree, String path) {
      final folderE = <MFsEntity>[];
      for (final entry in tree.entries) {
        final curPath = '$path/${entry.key}';

        if (entry.value is Map<String, dynamic>) {
          folderE.add(getFolder(entry.value, curPath));
        } else if (entry.value is Map<dynamic, dynamic>) {
          folderE.add(MFolder(entry.key, curPath, entries: []));
        } else {
          folderE.add(MFile(entry.key, curPath, content: entry.value));
        }
      }
      return MFolder(path.split('/').last, path, entries: folderE);
    }

    return getFolder(tree, 'root');
  }

  @override
  String toString() {
    return 'folder: $path\n ${entries.join('\n')}';
  }
}

class InMemoryGeneratorRepository extends GeneratorRepository {
  final MFolder root;
  final Map<String, Uint8List> _files = {};

  InMemoryGeneratorRepository({required Map<String, dynamic> tree})
    : root = MFolder.generate(tree);

  String contentsOf(String path) =>
      String.fromCharCodes(_files[path] ?? Uint8List(0));

  @override
  Future<bool> exists(FsEntity path) async {
    return _get(path) != null;
  }

  bool existsByString(String path) {
    return _files.containsKey(path);
  }

  MFsEntity? _get(FsEntity path) {
    MFolder curFolder = MFolder('/', '/', entries: [root]);

    for (final route in path.path.split('/')) {
      final res = curFolder.entries.firstWhereOrNull((e) => e.route == route);

      if (res == null) {
        return null;
      }

      if (res is MFile) {
        if (path.nameWithType == res.route) {
          return res;
        }
        return null;
      }

      curFolder = res as MFolder;
    }
    return curFolder;
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
    return String.fromCharCodes(
      content,
    ).split('\n').where((line) => line.isNotEmpty).toList();
  }

  @override
  Future<Set<FsEntity>> listFolderEntry(Folder path) async {
    return (_get(path) as MFolder).entries
        .map((e) => FsEntity.fromPath(e.path))
        .toSet();
  }

  @override
  Future<void> renameFile(FsFile file, FsFile newFile) async {
    final content = _files.remove(file.path);
    if (content != null) {
      _files[newFile.path] = content;
    }
  }
}
