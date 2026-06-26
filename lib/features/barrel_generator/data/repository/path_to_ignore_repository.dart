import 'package:barrel_generator/core/constants.dart';
import 'package:barrel_generator/features/barrel_generator/data/source/path_to_ignore_source.dart';
import 'package:barrel_generator/features/barrel_generator/domain/repository/path_to_ignore_repository.dart';
import 'package:injectable/injectable.dart';

@singleton
class PathsToIgnoreRepositoryImpl implements PathToIgnoreRepository {
  final String workingDirectory;
  final PathToIgnoreSource source;

  PathsToIgnoreRepositoryImpl({required this.source, @Named(worDirName) required this.workingDirectory});

  final Set<String> _oneStar = {};
  final Set<String> _absolutePathsToIgnore = {};
  final Set<String> _twoStar = {};

  @PostConstruct()
  Future<void> getPathsToIgnore() async {
    final paths = await source.getGitIgnore();

    try {
      final rootAndNonLibFilesRegExp = RegExp(r'(^[*\\\/])|(^lib)');

      final ignore = paths
          .where((text) => !text.startsWith('#') && text.isNotEmpty)
          .where((text) => rootAndNonLibFilesRegExp.hasMatch(text))
          .toList();

      final absolutePathRegExp = RegExp(r'\*');

      final ignoreWithStars = {...ignore}
        ..removeWhere((text) => !absolutePathRegExp.hasMatch(text));

      _absolutePathsToIgnore.addAll(ignore.toSet().difference(ignoreWithStars));

      _twoStar.addAll(
        ignoreWithStars
            .removeWhereAndReturn((text) => text.startsWith('**'))
            .map((text) => text.replaceAll('**', '')),
      );

      _oneStar.addAll(ignoreWithStars.difference(_twoStar));
    } catch (e) {
      print('can not get ignored files');
    }
  }

  @override
  bool isIgnored(String path) {
    if (!(path.contains('$workingDirectory/') ||
        path.contains('$workingDirectory\\') )) {
      return true;
    }

    if (_absolutePathsToIgnore.contains(path)) return true;

    for (final pattern in _twoStar) {
      if (path.contains(pattern)) {
        return true;
      }
    }

    for (final pattern in _oneStar) {
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
    final toRemove = where(test).toList();
    removeWhere(test);

    return toRemove;
  }
}
