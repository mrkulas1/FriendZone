/// Class to handle JSON serialization/deserialization for an Event object

import '../event.dart';
import 'json_builder.dart';
import 'json_list_builder.dart';

class EventBuilder extends JsonBuilder<Event> with JsonListBuilder<Event> {
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

  @override
  List<dynamic> listToJson(List<Event> obj) {
    // TODO: implement listToJson
    throw UnimplementedError();
  }

  @override
  List<Event> listFromJson(List<dynamic> json) {
    // TODO: implement listFromJson
    throw UnimplementedError();
  }
}
