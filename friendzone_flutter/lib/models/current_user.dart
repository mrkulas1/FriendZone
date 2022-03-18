import 'package:friendzone_flutter/models/event.dart';

/// Class representing the User that is currently logged into the app. Contains
/// private data that should only be pulled from the database if the user
/// is authenticated.

class CurrentUser {
  String email;
  String name;
  String introduction;
  String contact;

  List<Event> joinedEvents = [];

  bool _admin = false;

  CurrentUser(
      {required this.email,
      required this.name,
      required this.introduction,
      required this.contact});

  void addEvent(Event e) {
    joinedEvents.add(e);
  }
}
