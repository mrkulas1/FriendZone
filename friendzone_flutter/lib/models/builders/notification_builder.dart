/// Class to handle JSON serialization/deserialization for a Notification object

import 'dart:developer';

import 'package:friendzone_flutter/models/builders/json_builder.dart';
import 'package:friendzone_flutter/models/builders/json_list_builder.dart';
import '../notification.dart';

class NotificationBuilder extends JsonBuilder<Notification>
    with JsonListBuilder<Notification> {
  @override
  Notification fromJson(Map<String, dynamic> json) {
    DateTime timestamp = DateTime.parse(json["time"] ?? "");
    String eventTitle = json["event_title"] ?? "";
    String user = json["instigator"] ?? "";
    String comment = json["Comment"] ?? "";
    bool seen = (int.parse(json["seen"] ?? 0) == 1);
    int id = int.parse(json["notification_id"]);

    int type = int.parse(json["type"]);

    NotificationType nType = NotificationType.noType;

    switch (type) {
      case 1:
        nType = NotificationType.userJoinedEvent;
        break;
      case 2:
        nType = NotificationType.userLeftEvent;
        break;
      case 3:
        nType = NotificationType.eventDeleted;
        break;
      case 4:
        nType = NotificationType.eventChanged;
        break;
      default:
        break;
    }

    return Notification(
        id: id,
        time: timestamp,
        type: nType,
        eventTitle: eventTitle,
        userEmail: user,
        comment: comment,
        seen: seen);
  }

  @override
  List<Notification> listFromJson(List<dynamic> json) {
    List<Notification> notifications = [];

    for (var notif in json) {
      notifications.add(fromJson(notif));
    }

    return notifications;
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
