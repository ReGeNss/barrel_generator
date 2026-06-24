import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/fs_entity.dart';

part 'events.freezed.dart';

@freezed
sealed class Event with _$Event {
  const factory Event.createdFile({required FsFile file}) = CreateFileEvent;

  const factory Event.createdFolder({required Folder folder}) = CreateFolderEvent;

  const factory Event.renamedFolder({
    required Folder folder,
    required Folder oldFolder,
  }) = RenamedFolderEvent;

  const factory Event.removedFile({required FsFile file}) = RemovedFileEvent;

  const factory Event.removedFolder({required Folder folder}) = RemovedFolderEvent;
}
