import 'package:barrel_generator/features/barrel_generator/data/repository/non_barrel_path_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Non barrel path repo', () {
    final repo = NonBarrelPathRepository('lib');

    test(
      "should ignore new file in root",
      () {
        expect(repo.isIgnored('lib/new.dart'), isTrue);
      },
    );

    test(
      "should ignore new folder in root",
      () {
        expect(repo.isIgnored('lib/folder'), isTrue);
      },
    );
  });
}