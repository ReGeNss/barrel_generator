// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Event {

 Path get path;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'Event(path: $path)';
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CreateFileEvent value)?  createdFile,TResult Function( CreateFolderEvent value)?  createdFolder,TResult Function( RenamedFolderEvent value)?  renamedFolder,TResult Function( RenamedFileEvent value)?  renamedFile,TResult Function( RemovedFileEvent value)?  removedFile,TResult Function( RemovedFolderEvent value)?  removedFolder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that);case RenamedFileEvent() when renamedFile != null:
return renamedFile(_that);case RemovedFileEvent() when removedFile != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CreateFileEvent value)  createdFile,required TResult Function( CreateFolderEvent value)  createdFolder,required TResult Function( RenamedFolderEvent value)  renamedFolder,required TResult Function( RenamedFileEvent value)  renamedFile,required TResult Function( RemovedFileEvent value)  removedFile,required TResult Function( RemovedFolderEvent value)  removedFolder,}){
final _that = this;
switch (_that) {
case CreateFileEvent():
return createdFile(_that);case CreateFolderEvent():
return createdFolder(_that);case RenamedFolderEvent():
return renamedFolder(_that);case RenamedFileEvent():
return renamedFile(_that);case RemovedFileEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CreateFileEvent value)?  createdFile,TResult? Function( CreateFolderEvent value)?  createdFolder,TResult? Function( RenamedFolderEvent value)?  renamedFolder,TResult? Function( RenamedFileEvent value)?  renamedFile,TResult? Function( RemovedFileEvent value)?  removedFile,TResult? Function( RemovedFolderEvent value)?  removedFolder,}){
final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that);case RenamedFileEvent() when renamedFile != null:
return renamedFile(_that);case RemovedFileEvent() when removedFile != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( FilePath path)?  createdFile,TResult Function( FolderPath path)?  createdFolder,TResult Function( FolderPath path,  FolderPath oldLocation)?  renamedFolder,TResult Function( FilePath path,  FilePath oldLocation)?  renamedFile,TResult Function( FilePath path)?  removedFile,TResult Function( FolderPath path)?  removedFolder,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that.path);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that.path);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that.path,_that.oldLocation);case RenamedFileEvent() when renamedFile != null:
return renamedFile(_that.path,_that.oldLocation);case RemovedFileEvent() when removedFile != null:
return removedFile(_that.path);case RemovedFolderEvent() when removedFolder != null:
return removedFolder(_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( FilePath path)  createdFile,required TResult Function( FolderPath path)  createdFolder,required TResult Function( FolderPath path,  FolderPath oldLocation)  renamedFolder,required TResult Function( FilePath path,  FilePath oldLocation)  renamedFile,required TResult Function( FilePath path)  removedFile,required TResult Function( FolderPath path)  removedFolder,}) {final _that = this;
switch (_that) {
case CreateFileEvent():
return createdFile(_that.path);case CreateFolderEvent():
return createdFolder(_that.path);case RenamedFolderEvent():
return renamedFolder(_that.path,_that.oldLocation);case RenamedFileEvent():
return renamedFile(_that.path,_that.oldLocation);case RemovedFileEvent():
return removedFile(_that.path);case RemovedFolderEvent():
return removedFolder(_that.path);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( FilePath path)?  createdFile,TResult? Function( FolderPath path)?  createdFolder,TResult? Function( FolderPath path,  FolderPath oldLocation)?  renamedFolder,TResult? Function( FilePath path,  FilePath oldLocation)?  renamedFile,TResult? Function( FilePath path)?  removedFile,TResult? Function( FolderPath path)?  removedFolder,}) {final _that = this;
switch (_that) {
case CreateFileEvent() when createdFile != null:
return createdFile(_that.path);case CreateFolderEvent() when createdFolder != null:
return createdFolder(_that.path);case RenamedFolderEvent() when renamedFolder != null:
return renamedFolder(_that.path,_that.oldLocation);case RenamedFileEvent() when renamedFile != null:
return renamedFile(_that.path,_that.oldLocation);case RemovedFileEvent() when removedFile != null:
return removedFile(_that.path);case RemovedFolderEvent() when removedFolder != null:
return removedFolder(_that.path);case _:
  return null;

}
}

}

/// @nodoc


class CreateFileEvent implements Event {
  const CreateFileEvent({required this.path});
  

@override final  FilePath path;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateFileEventCopyWith<CreateFileEvent> get copyWith => _$CreateFileEventCopyWithImpl<CreateFileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateFileEvent&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'Event.createdFile(path: $path)';
}


}

/// @nodoc
abstract mixin class $CreateFileEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $CreateFileEventCopyWith(CreateFileEvent value, $Res Function(CreateFileEvent) _then) = _$CreateFileEventCopyWithImpl;
@useResult
$Res call({
 FilePath path
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(CreateFileEvent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as FilePath,
  ));
}


}

/// @nodoc


class CreateFolderEvent implements Event {
  const CreateFolderEvent({required this.path});
  

@override final  FolderPath path;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateFolderEventCopyWith<CreateFolderEvent> get copyWith => _$CreateFolderEventCopyWithImpl<CreateFolderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateFolderEvent&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'Event.createdFolder(path: $path)';
}


}

/// @nodoc
abstract mixin class $CreateFolderEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $CreateFolderEventCopyWith(CreateFolderEvent value, $Res Function(CreateFolderEvent) _then) = _$CreateFolderEventCopyWithImpl;
@useResult
$Res call({
 FolderPath path
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(CreateFolderEvent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as FolderPath,
  ));
}


}

/// @nodoc


class RenamedFolderEvent implements Event {
  const RenamedFolderEvent({required this.path, required this.oldLocation});
  

@override final  FolderPath path;
 final  FolderPath oldLocation;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenamedFolderEventCopyWith<RenamedFolderEvent> get copyWith => _$RenamedFolderEventCopyWithImpl<RenamedFolderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenamedFolderEvent&&(identical(other.path, path) || other.path == path)&&(identical(other.oldLocation, oldLocation) || other.oldLocation == oldLocation));
}


@override
int get hashCode => Object.hash(runtimeType,path,oldLocation);

@override
String toString() {
  return 'Event.renamedFolder(path: $path, oldLocation: $oldLocation)';
}


}

/// @nodoc
abstract mixin class $RenamedFolderEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RenamedFolderEventCopyWith(RenamedFolderEvent value, $Res Function(RenamedFolderEvent) _then) = _$RenamedFolderEventCopyWithImpl;
@useResult
$Res call({
 FolderPath path, FolderPath oldLocation
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? oldLocation = null,}) {
  return _then(RenamedFolderEvent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as FolderPath,oldLocation: null == oldLocation ? _self.oldLocation : oldLocation // ignore: cast_nullable_to_non_nullable
as FolderPath,
  ));
}


}

/// @nodoc


class RenamedFileEvent implements Event {
  const RenamedFileEvent({required this.path, required this.oldLocation});
  

@override final  FilePath path;
 final  FilePath oldLocation;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenamedFileEventCopyWith<RenamedFileEvent> get copyWith => _$RenamedFileEventCopyWithImpl<RenamedFileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenamedFileEvent&&(identical(other.path, path) || other.path == path)&&(identical(other.oldLocation, oldLocation) || other.oldLocation == oldLocation));
}


@override
int get hashCode => Object.hash(runtimeType,path,oldLocation);

@override
String toString() {
  return 'Event.renamedFile(path: $path, oldLocation: $oldLocation)';
}


}

/// @nodoc
abstract mixin class $RenamedFileEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RenamedFileEventCopyWith(RenamedFileEvent value, $Res Function(RenamedFileEvent) _then) = _$RenamedFileEventCopyWithImpl;
@useResult
$Res call({
 FilePath path, FilePath oldLocation
});




}
/// @nodoc
class _$RenamedFileEventCopyWithImpl<$Res>
    implements $RenamedFileEventCopyWith<$Res> {
  _$RenamedFileEventCopyWithImpl(this._self, this._then);

  final RenamedFileEvent _self;
  final $Res Function(RenamedFileEvent) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? oldLocation = null,}) {
  return _then(RenamedFileEvent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as FilePath,oldLocation: null == oldLocation ? _self.oldLocation : oldLocation // ignore: cast_nullable_to_non_nullable
as FilePath,
  ));
}


}

/// @nodoc


class RemovedFileEvent implements Event {
  const RemovedFileEvent({required this.path});
  

@override final  FilePath path;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovedFileEventCopyWith<RemovedFileEvent> get copyWith => _$RemovedFileEventCopyWithImpl<RemovedFileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovedFileEvent&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'Event.removedFile(path: $path)';
}


}

/// @nodoc
abstract mixin class $RemovedFileEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RemovedFileEventCopyWith(RemovedFileEvent value, $Res Function(RemovedFileEvent) _then) = _$RemovedFileEventCopyWithImpl;
@useResult
$Res call({
 FilePath path
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(RemovedFileEvent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as FilePath,
  ));
}


}

/// @nodoc


class RemovedFolderEvent implements Event {
  const RemovedFolderEvent({required this.path});
  

@override final  FolderPath path;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemovedFolderEventCopyWith<RemovedFolderEvent> get copyWith => _$RemovedFolderEventCopyWithImpl<RemovedFolderEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemovedFolderEvent&&(identical(other.path, path) || other.path == path));
}


@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'Event.removedFolder(path: $path)';
}


}

/// @nodoc
abstract mixin class $RemovedFolderEventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory $RemovedFolderEventCopyWith(RemovedFolderEvent value, $Res Function(RemovedFolderEvent) _then) = _$RemovedFolderEventCopyWithImpl;
@useResult
$Res call({
 FolderPath path
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
@pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(RemovedFolderEvent(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as FolderPath,
  ));
}


}

// dart format on
