/// Class to handle JSON serialization/deserialization for a Notification object

import 'package:friendzone_flutter/models/builders/json_builder.dart';
import 'package:friendzone_flutter/models/builders/json_list_builder.dart';
import '../notification.dart';

class NotificationBuilder extends JsonBuilder<Notification>
    with JsonListBuilder<Notification> {
  @override
  Notification fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  List<Notification> listFromJson(List json) {
    // TODO: implement listFromJson
    throw UnimplementedError();
  }

  @override
  List listToJson(List<Notification> obj) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(Notification obj) {
    throw UnimplementedError();
  }
}
