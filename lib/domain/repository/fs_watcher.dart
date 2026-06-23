import 'package:barrel_generator/domain/events/events.dart';

abstract class FsWatcher {
  Stream<Event> getEvents();
}