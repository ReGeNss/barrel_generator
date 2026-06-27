import 'package:barrel_generator/features/features.dart';

abstract class ProjectGenerateRepository {
  Future<List<FsEntity>> getFlatTree(Folder folder);
}

