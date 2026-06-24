import 'package:barrel_generator/features/barrel_generator/domain/entity/fs_entity.dart';

abstract class ProjectGenerateRepository {
  Future<List<Folder>> getFlatTree(Folder folder);
}

