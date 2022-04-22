import 'package:friendzone_flutter/models/builders/json_builder.dart';
import 'package:friendzone_flutter/models/builders/json_list_builder.dart';

/// Class to handle the JSON serialization / deserialization of a list of
/// Strings, in order to build the report list for an event
class CommentBuilder extends JsonBuilder<String> with JsonListBuilder<String> {
  @override
  String fromJson(Map<String, dynamic> json) {
    return json["comment"] ?? "";
  }

  @override
  List<String> listFromJson(List json) {
    List<String> comments = [];

    for (var comment in json) {
      comments.add(fromJson(comment));
    }

    return comments;
  }

  @override
  List listToJson(List<String> obj) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(String obj) {
    throw UnimplementedError();
  }
}
