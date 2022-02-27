/// Class to handle JSON serialization/deserialization for an Event object
///

import '../event.dart';
import 'json_builder.dart';

class EventBuilder extends JsonBuilder<Event> {
  @override
  Map<String, dynamic> toJson(Event obj) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  Event fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
