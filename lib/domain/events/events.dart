import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/path.dart';

part 'events.freezed.dart';

@freezed
sealed class Event with _$Event {
  const factory Event.createdFile({required FilePath path}) = CreateFileEvent;

  const factory Event.createdFolder({required FilePath path}) = CreateFolderEvent;

  const factory Event.renamedFolder({
    required FilePath path,
    required FilePath oldLocation,
  }) = RenamedFolderEvent;

  const factory Event.removedFile({required FilePath path}) = RemovedFileEvent;

  const factory Event.removedFolder({required FilePath path}) = RemovedFolderEvent;
}
