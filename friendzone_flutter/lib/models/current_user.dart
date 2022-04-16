import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';

/// Class representing the User that is currently logged into the app. Contains
/// private data that should only be pulled from the database if the user
/// is authenticated.

class CurrentUser extends ForeignUser {
  CurrentUser(String email, String name, String introduction, String contact)
      : super(
            email: email,
            name: name,
            introduction: introduction,
            contact: contact);

  bool _admin = false;

  String token = "";

  void setToken(String t) {
    token = t;
  }

  void makeAdmin() {
    _admin = true;
  }

  bool isAdmin() {
    return _admin;
  }
}
