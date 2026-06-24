import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';
import 'package:barrel_generator/features/project_generator/data/repository/project_generate_repository_impl.dart';
import 'package:test/test.dart';

import '../source/project_generate_source.dart';

void main() {
  group('Project generate repository tests', () {
    test(
      "Returns only the root folder when it has no subdirectories",
      () async {
        final repo = ProjectGenerateRepositoryImpl(sources: ProjectGenerateSourceMock({}));

        final result = await repo.getFlatTree(Folder('root'));

        expect(result.map((folder) => folder.path), ['root']);
      },
    );

    test(
      "Flattens a nested directory tree depth-first",
      () async {
        final repo = ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock({
            'root': ['root/a', 'root/b'],
            'root/a': ['root/a/a1', 'root/a/a2'],
          }),
        );

        final result = await repo.getFlatTree(Folder('root'));

        expect(result.map((folder) => folder.path), [
          'root',
          'root/a',
          'root/a/a1',
          'root/a/a2',
          'root/b',
        ]);
      },
    );

    test(
      "Returns Folder instances for every entry",
      () async {
        final repo = ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock({'root': ['root/a']}),
        );

        final result = await repo.getFlatTree(Folder('root'));

        expect(result, everyElement(isA<Folder>()));
      },
    );

    test(
      "Includes the root folder itself in the result",
      () async {
        final root = Folder('root');
        final repo = ProjectGenerateRepositoryImpl(
          sources: ProjectGenerateSourceMock({'root': ['root/a']}),
        );

        final result = await repo.getFlatTree(root);

        expect(result.first, same(root));
      },
    );
  });
}
