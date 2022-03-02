import 'package:friendzone_flutter/models/auth_result.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/event.dart';

import 'package:friendzone_flutter/models/builders/auth_result_builder.dart';
import 'package:friendzone_flutter/models/builders/current_user_builder.dart';
import 'package:friendzone_flutter/models/builders/event_builder.dart';

import 'make_post_request.dart';
import 'dart:async';

/// This file contains all functions that are used by the UI to interface with
/// the PHP/DB layer of the app

/// Authenticate the attempted login with the credentials of [email] and
/// [password]
Future<AuthResult> authenticate(String email, String password) async {
  Map<String, dynamic> input = {"email": email, "password": password};
  Map<int, String> errorMessages = buildErrorMessages();

  AuthResult authResult = await makePostRequest(
      PHPFunction.auth, input, errorMessages, AuthResultBuilder());

  if (!authResult.success()) {
    return authResult;
  }

  input.clear();
  input = {"email": email};

  CurrentUser user = await makePostRequest(
      PHPFunction.getCurrentUser, input, errorMessages, CurrentUserBuilder());

  authResult.setUser(user);

  return authResult;
}

/// Register a user with the given [email], [password], [name], [intro], and
/// [contactInfo]. Throw an exception on failure.
Future<CurrentUser> register(String email, String password, String name,
    String intro, String contactInfo) async {
  Map<String, dynamic> input = {
    "email": email,
    "password": password,
    "name": name,
    "intro": intro,
    "contact": contactInfo
  };

  Map<int, String> errorMessages = buildErrorMessages(
      alreadyThereMessage:
          "A user with this email is already registered. Try logging in",
      internalErrorMessage: """Failed to create the user. 
          Check your internet connection and try again""");

  CurrentUser user = await makePostRequest(
      PHPFunction.createUser, input, errorMessages, CurrentUserBuilder());

  return user;
}

/// Get a list of the basic info for all Events. Throw an exception on failure.
Future<List<Event>> getAllEvents() async {
  Map<String, dynamic> input = {};
  Map<int, String> errorMessages =
      buildErrorMessages(internalErrorMessage: """Failed to retrieve events. 
          Check your internet connection and try again.""");

  List<Event> events = await makeListPostRequest(
      PHPFunction.getAllEvents, input, errorMessages, EventBuilder());

  return events;
}

/// Get all information about one event. Throw an exception on failure.
Future<Event> getDetailedEvent(int eventID) async {
  Map<String, dynamic> input = {"id": eventID};

  Map<int, String> errorMessages = buildErrorMessages(
      notFoundMessage: "Requested event was not found.",
      internalErrorMessage: """Failed to retrieve event data. 
    Check your internet connection and try again.""");

  Event event = await makePostRequest(
      PHPFunction.getDetailedEvent, input, errorMessages, EventBuilder());

  return event;
}

/// Create a new event with the given owner [userEmail], [title], [description],
/// [location], [time], number of [slots], and [category].
Future<Event> createEvent(String userEmail, String title, String description,
    String location, String time, int slots, int category) async {
  Map<String, dynamic> input = {
    "userEmail": userEmail,
    "title": title,
    "description": description,
    "location": location,
    "time": time,
    "slots": slots,
    "category": category
  };

  Map<int, String> errorMessages =
      buildErrorMessages(internalErrorMessage: """Failed to create the event. 
      Check your internetconnection and try again.""");

  Event event = await makePostRequest(
      PHPFunction.createEvent, input, errorMessages, EventBuilder());

  return event;
}

/// Add the user with email [userEmail] to the event with ID [eventID], with
/// a given [comment]. Will update the existing join comment if the user has
/// already joined the event.
Future<bool> joinEvent(String userEmail, int eventID, String comment) async {
  throw UnimplementedError();
}
