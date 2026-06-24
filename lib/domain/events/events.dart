import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/fs_entity.dart';

part 'events.freezed.dart';

@freezed
sealed class Event with _$Event {
  const factory Event.createdFile({required FsFile path}) = CreateFileEvent;

  const factory Event.createdFolder({required Folder path}) = CreateFolderEvent;

  const factory Event.renamedFolder({
    required Folder path,
    required Folder oldLocation,
  }) = RenamedFolderEvent;

  const factory Event.removedFile({required FsFile path}) = RemovedFileEvent;

  const factory Event.removedFolder({required Folder path}) = RemovedFolderEvent;
}
