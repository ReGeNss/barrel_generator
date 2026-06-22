import 'package:barrel_generator/domain/entity/path.dart';

abstract class GeneratorRepository {
  void createFile(FilePath location);
  void editFile(FilePath location, String newData);
  bool pathValid(String path);
}
