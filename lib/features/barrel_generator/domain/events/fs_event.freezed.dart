// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fs_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Event {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Event()';
}


}

/// @nodoc
class $EventCopyWith<$Res>  {
$EventCopyWith(Event _, $Res Function(Event) __);
}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CreateFileEvent value)?  createdFile,TResult Function( CreateFolderEvent value)?  createdFolder,TResult Function( RenamedFolderEvent value)?  renamedFolder,TResult Function( RemovedFileEvent value)?  removedFile,TResult Function( RemovedFolderEvent value)?  removedFolder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that);case RemovedFileEvent() when removedFile != null:
return removedFile(_that);case RemovedFolderEvent() when removedFolder != null:
return removedFolder(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CreateFileEvent value)  createdFile,required TResult Function( CreateFolderEvent value)  createdFolder,required TResult Function( RenamedFolderEvent value)  renamedFolder,required TResult Function( RemovedFileEvent value)  removedFile,required TResult Function( RemovedFolderEvent value)  removedFolder,}){
final _that = this;
switch (_that) {
case CreateFileEvent():
return createdFile(_that);case CreateFolderEvent():
return createdFolder(_that);case RenamedFolderEvent():
return renamedFolder(_that);case RemovedFileEvent():
return removedFile(_that);case RemovedFolderEvent():
return removedFolder(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CreateFileEvent value)?  createdFile,TResult? Function( CreateFolderEvent value)?  createdFolder,TResult? Function( RenamedFolderEvent value)?  renamedFolder,TResult? Function( RemovedFileEvent value)?  removedFile,TResult? Function( RemovedFolderEvent value)?  removedFolder,}){
final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that);case RemovedFileEvent() when removedFile != null:
return removedFile(_that);case RemovedFolderEvent() when removedFolder != null:
return removedFolder(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FsFile file)?  createdFile,TResult Function( Folder folder)?  createdFolder,TResult Function( Folder folder,  Folder oldFolder)?  renamedFolder,TResult Function( FsFile file)?  removedFile,TResult Function( Folder folder)?  removedFolder,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that.file);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that.folder);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that.folder,_that.oldFolder);case RemovedFileEvent() when removedFile != null:
return removedFile(_that.file);case RemovedFolderEvent() when removedFolder != null:
return removedFolder(_that.folder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FsFile file)  createdFile,required TResult Function( Folder folder)  createdFolder,required TResult Function( Folder folder,  Folder oldFolder)  renamedFolder,required TResult Function( FsFile file)  removedFile,required TResult Function( Folder folder)  removedFolder,}) {final _that = this;
switch (_that) {
case CreateFileEvent():
return createdFile(_that.file);case CreateFolderEvent():
return createdFolder(_that.folder);case RenamedFolderEvent():
return renamedFolder(_that.folder,_that.oldFolder);case RemovedFileEvent():
return removedFile(_that.file);case RemovedFolderEvent():
return removedFolder(_that.folder);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FsFile file)?  createdFile,TResult? Function( Folder folder)?  createdFolder,TResult? Function( Folder folder,  Folder oldFolder)?  renamedFolder,TResult? Function( FsFile file)?  removedFile,TResult? Function( Folder folder)?  removedFolder,}) {final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that.file);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that.folder);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that.folder,_that.oldFolder);case RemovedFileEvent() when removedFile != null:
return removedFile(_that.file);case RemovedFolderEvent() when removedFolder != null:
return removedFolder(_that.folder);case _:
  return null;

}
}

}

/// @nodoc


class CreateFileEvent implements Event {
  const CreateFileEvent({required this.file});
  

 final  FsFile file;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateFileEventCopyWith<CreateFileEvent> get copyWith => _$CreateFileEventCopyWithImpl<CreateFileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateFileEvent&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'Event.createdFile(file: $file)';
}


}

/// @nodoc
abstract mixin class $CreateFileEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $CreateFileEventCopyWith(CreateFileEvent value, $Res Function(CreateFileEvent) _then) = _$CreateFileEventCopyWithImpl;
@useResult
$Res call({
 FsFile file
});




}
/// @nodoc
class _$CreateFileEventCopyWithImpl<$Res>
    implements $CreateFileEventCopyWith<$Res> {
  _$CreateFileEventCopyWithImpl(this._self, this._then);

  final CreateFileEvent _self;
  final $Res Function(CreateFileEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(CreateFileEvent(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as FsFile,
  ));
}


}

/// @nodoc


class CreateFolderEvent implements Event {
  const CreateFolderEvent({required this.folder});
  

 final  Folder folder;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateFolderEventCopyWith<CreateFolderEvent> get copyWith => _$CreateFolderEventCopyWithImpl<CreateFolderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateFolderEvent&&(identical(other.folder, folder) || other.folder == folder));
}


@override
int get hashCode => Object.hash(runtimeType,folder);

@override
String toString() {
  return 'Event.createdFolder(folder: $folder)';
}


}

/// @nodoc
abstract mixin class $CreateFolderEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $CreateFolderEventCopyWith(CreateFolderEvent value, $Res Function(CreateFolderEvent) _then) = _$CreateFolderEventCopyWithImpl;
@useResult
$Res call({
 Folder folder
});




}
/// @nodoc
class _$CreateFolderEventCopyWithImpl<$Res>
    implements $CreateFolderEventCopyWith<$Res> {
  _$CreateFolderEventCopyWithImpl(this._self, this._then);

  final CreateFolderEvent _self;
  final $Res Function(CreateFolderEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folder = null,}) {
  return _then(CreateFolderEvent(
folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as Folder,
  ));
}


}

/// @nodoc


class RenamedFolderEvent implements Event {
  const RenamedFolderEvent({required this.folder, required this.oldFolder});
  

 final  Folder folder;
 final  Folder oldFolder;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenamedFolderEventCopyWith<RenamedFolderEvent> get copyWith => _$RenamedFolderEventCopyWithImpl<RenamedFolderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenamedFolderEvent&&(identical(other.folder, folder) || other.folder == folder)&&(identical(other.oldFolder, oldFolder) || other.oldFolder == oldFolder));
}


@override
int get hashCode => Object.hash(runtimeType,folder,oldFolder);

@override
String toString() {
  return 'Event.renamedFolder(folder: $folder, oldFolder: $oldFolder)';
}


}

/// @nodoc
abstract mixin class $RenamedFolderEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RenamedFolderEventCopyWith(RenamedFolderEvent value, $Res Function(RenamedFolderEvent) _then) = _$RenamedFolderEventCopyWithImpl;
@useResult
$Res call({
 Folder folder, Folder oldFolder
});




}
/// @nodoc
class _$RenamedFolderEventCopyWithImpl<$Res>
    implements $RenamedFolderEventCopyWith<$Res> {
  _$RenamedFolderEventCopyWithImpl(this._self, this._then);

  final RenamedFolderEvent _self;
  final $Res Function(RenamedFolderEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folder = null,Object? oldFolder = null,}) {
  return _then(RenamedFolderEvent(
folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as Folder,oldFolder: null == oldFolder ? _self.oldFolder : oldFolder // ignore: cast_nullable_to_non_nullable
as Folder,
  ));
}


}

/// @nodoc


class RemovedFileEvent implements Event {
  const RemovedFileEvent({required this.file});
  

 final  FsFile file;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovedFileEventCopyWith<RemovedFileEvent> get copyWith => _$RemovedFileEventCopyWithImpl<RemovedFileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovedFileEvent&&(identical(other.file, file) || other.file == file));
}


@override
int get hashCode => Object.hash(runtimeType,file);

@override
String toString() {
  return 'Event.removedFile(file: $file)';
}


}

/// @nodoc
abstract mixin class $RemovedFileEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RemovedFileEventCopyWith(RemovedFileEvent value, $Res Function(RemovedFileEvent) _then) = _$RemovedFileEventCopyWithImpl;
@useResult
$Res call({
 FsFile file
});




}
/// @nodoc
class _$RemovedFileEventCopyWithImpl<$Res>
    implements $RemovedFileEventCopyWith<$Res> {
  _$RemovedFileEventCopyWithImpl(this._self, this._then);

  final RemovedFileEvent _self;
  final $Res Function(RemovedFileEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,}) {
  return _then(RemovedFileEvent(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as FsFile,
  ));
}


}

/// @nodoc


class RemovedFolderEvent implements Event {
  const RemovedFolderEvent({required this.folder});
  

 final  Folder folder;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovedFolderEventCopyWith<RemovedFolderEvent> get copyWith => _$RemovedFolderEventCopyWithImpl<RemovedFolderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovedFolderEvent&&(identical(other.folder, folder) || other.folder == folder));
}


@override
int get hashCode => Object.hash(runtimeType,folder);

@override
String toString() {
  return 'Event.removedFolder(folder: $folder)';
}


}

/// @nodoc
abstract mixin class $RemovedFolderEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RemovedFolderEventCopyWith(RemovedFolderEvent value, $Res Function(RemovedFolderEvent) _then) = _$RemovedFolderEventCopyWithImpl;
@useResult
$Res call({
 Folder folder
});




}
/// @nodoc
class _$RemovedFolderEventCopyWithImpl<$Res>
    implements $RemovedFolderEventCopyWith<$Res> {
  _$RemovedFolderEventCopyWithImpl(this._self, this._then);

  final RemovedFolderEvent _self;
  final $Res Function(RemovedFolderEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? folder = null,}) {
  return _then(RemovedFolderEvent(
folder: null == folder ? _self.folder : folder // ignore: cast_nullable_to_non_nullable
as Folder,
  ));
}


}

// dart format on
