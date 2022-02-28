import 'package:friendzone_flutter/models/auth_result.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/event.dart';

import 'package:friendzone_flutter/models/builders/auth_result_builder.dart';
import 'package:friendzone_flutter/models/builders/current_user_builder.dart';
import 'package:friendzone_flutter/models/builders/event_builder.dart';

import 'make_post.dart';
import 'dart:async';

/// This file contains all functions that are used by the UI to interface with
/// the PHP/DB layer of the app

/// Authenticate the attempted login with the credentials of [email] and
/// [password]
Future<AuthResult> authenticate(String email, String password) {
  throw UnimplementedError();
}

/// Register a user with the given [email], [password], [name], [intro], and
/// [contactInfo]. Throw an exception on failure.
Future<CurrentUser> register(
    String email, String password, String name, String intro) {
  throw UnimplementedError();
}

/// Get a list of the basic info for all Events. Throw an exception on failure.
Future<List<Event>> getAllEvents() {
  throw UnimplementedError();
}

/// Get all information about one event. Throw an exception on failure.
Future<Event> getDetailedEvent(int eventID) {
  throw UnimplementedError();
}

/// Create a new event with the given owner [userEmail], [title], [description],
/// number of [slots], and [category].
Future<Event> createEvent(String userEmail, String title, String description,
    int slots, int category) {
  throw UnimplementedError();
}

/// Add the user with email [userEmail] to the event with ID [eventID], with
/// a given [comment].
Future<bool> joinEvent(String userEmail, int eventID, String comment) {
  throw UnimplementedError();
}
