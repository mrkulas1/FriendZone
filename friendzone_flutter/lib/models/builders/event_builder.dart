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
    Event e = Event(
        id: int.parse(json["id"] ?? '0'),
        userEmail: json["email"] ?? "",
        title: json["title"] ?? "",
        time: json["time"] ?? "",
        location: json["location"] ?? "",
        slots: int.parse(json["slots"] ?? '0'),
        category: json["category"] ?? "",
        subCat: json["subcategory"] ?? "");

    if (json.containsKey("description") &&
        json.containsKey("reported") &&
        json.containsKey("date_created")) {
      e.makeDetailed(json["description"] ?? "",
          int.parse(json["reported"] ?? '0') == 1, json["date_created"] ?? "");
    }

    return e;
  }

  @override
  List<dynamic> listToJson(List<Event> obj) {
    // TODO: implement listToJson
    throw UnimplementedError();
  }

  @override
  List<Event> listFromJson(List<dynamic> json) {
    List<Event> events = [];

    for (var event in json) {
      events.add(fromJson(event));
    }

    return events;
  }
}
