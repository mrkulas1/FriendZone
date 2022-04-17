/// Class to represent a notification that is pulled off the database. The
/// message text of the notification is formatted based on the type, with
/// values based on

enum NotificationType {
  noType,
  userJoinedEvent,
  userLeftEvent,
  eventDeleted,
  eventChanged
}

class Notification {
  String? text;

  int id;
  DateTime time;
  NotificationType type;
  String eventTitle;
  String userEmail;
  String comment;
  bool seen;

  /// Create a notification, where [time] is the timestamp of the notification,
  /// [type] determines the format of the notification, [eventTitle] is the
  /// relevant event, and [userEmail] is the relevant email
  Notification(
      {required this.id,
      required this.time,
      required this.type,
      required this.eventTitle,
      required this.userEmail,
      required this.comment,
      required this.seen}) {
    _makeText();
  }

  void _makeText() {
    switch (type) {
      case NotificationType.userJoinedEvent:
        text =
            "User $userEmail signed up for your event $eventTitle, with the note: '$comment'";
        break;
      case NotificationType.userLeftEvent:
        text = "User $userEmail left your event $eventTitle";
        break;
      case NotificationType.eventChanged:
        text =
            "The event you were signed up for, $eventTitle, has been updated";
        break;
      case NotificationType.eventDeleted:
        text =
            "The event you were signed up for, $eventTitle, has been deleted";
        break;
      default:
        text = "Badly formatted notification";
    }
  }
}
