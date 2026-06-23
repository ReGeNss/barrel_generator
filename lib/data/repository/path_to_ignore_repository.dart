import 'package:barrel_generator/data/source/path_to_ignore_source.dart';
import 'package:barrel_generator/domain/repository/path_to_ignore_repository.dart';

class PathToIgnoreRepositoryImpl implements PathToIgnoreRepository {
  final String workingDirectory;
  final PathToIgnoreSource source;

  PathToIgnoreRepositoryImpl({required this.workingDirectory, required this.source}) {
    getPathsToIgnore();
  }

  final Set<String> _toIgnore = {};
  final Set<String> _absolutePathsToIgnore = {};
  final Set<String> _twoStar = {};

  Future<void> getPathsToIgnore() async {
    final paths = await source.getGitIgnore();

    try {
      final rootAndNonLibFilesRegExp = RegExp(r'(^[*\\\/])|(^lib)');

      final ignore = paths
          .where((text) => !text.startsWith('#') && text.isNotEmpty)
          .where((text) => rootAndNonLibFilesRegExp.hasMatch(text))
          .toList();

      final absolutePathRegExp = RegExp(r'\*');

      final toIgnoreList = {...ignore}
        ..removeWhere((text) => !absolutePathRegExp.hasMatch(text));

      _absolutePathsToIgnore.addAll(toIgnoreList.toSet().difference(_toIgnore));

      _twoStar.addAll(
        toIgnoreList
            .removeWhereAndReturn((text) => text.startsWith('**'))
            .map((text) => text.replaceAll('**', '')),
      );
    } catch (e) {
      print('can not get ignored files');
    }
  }

  @override
  bool isIgnored(String path) {
    if (!path.contains('$workingDirectory/') ||
        !path.contains('$workingDirectory\\') ) {
      return true;
    }

    if (_absolutePathsToIgnore.contains(path)) return true;

    for (final pattern in _twoStar) {
      if (path.contains(pattern)) {
        return true;
      }
    }

    for (final pattern in _toIgnore) {
      final parts = pattern.split('*');

      if (parts.every((part) => path.contains(part))) {
        return true;
      }
    }

    return false;
  }
}

extension RemoveWhere<T> on Set<T> {
  Iterable<T> removeWhereAndReturn(bool Function(T) test) {
    final toRemove = where(test);
    removeWhere(test);

    return toRemove;
  }
}
