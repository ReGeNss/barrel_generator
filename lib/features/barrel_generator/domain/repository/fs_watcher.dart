import 'package:barrel_generator/features/barrel_generator/domain/events/fs_event.dart';

abstract class FsWatcher {
  Stream<Event> getEvents();
}