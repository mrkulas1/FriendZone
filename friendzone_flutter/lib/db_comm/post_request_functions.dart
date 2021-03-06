import 'package:friendzone_flutter/models/auth_result.dart';
import 'package:friendzone_flutter/models/builders/comment_builder.dart';
import 'package:friendzone_flutter/models/builders/foreign_user_builder.dart';
import 'package:friendzone_flutter/models/builders/notification_builder.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/event.dart';

import 'package:friendzone_flutter/models/builders/auth_result_builder.dart';
import 'package:friendzone_flutter/models/builders/current_user_builder.dart';
import 'package:friendzone_flutter/models/builders/event_builder.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';
import 'package:friendzone_flutter/models/notification.dart';

import 'make_post_request.dart';
import 'dart:async';

// This file contains all functions that are used by the UI to interface with
// the PHP/DB layer of the app

/// Authenticate the attempted login with the credentials of [email] and
/// [password]
Future<AuthResult> authenticate(String email, String password) async {
  email = email.replaceAll(" ", "");

  Map<String, dynamic> input = {"email": email, "password": password};

  AuthResult authResult =
      await makePostRequest(PHPFunction.auth, input, AuthResultBuilder());

  return authResult;
}

/// Register a user with the given [email], [password], [name], [intro], and
/// [contactInfo]. Throw an exception on failure.
Future<CurrentUser> register(String email, String password, String name,
    String intro, String contactInfo) async {
  email = email.replaceAll(" ", "");

  Map<String, dynamic> input = {
    "email": email,
    "password": password,
    "name": name,
    "intro": intro,
    "contact": contactInfo
  };

  CurrentUser user = await makePostRequest(
      PHPFunction.createUser, input, CurrentUserBuilder());

  return user;
}

/// Get a list of the basic info for all Events. Throw an exception on failure.
Future<List<Event>> getAllEvents() async {
  Map<String, dynamic> input = {};

  List<Event> events = await makeListPostRequest(
      PHPFunction.getAllEvents, input, EventBuilder());

  return events;
}

/// Get all information about the event with id [eventID]. Throw an exception on failure.
Future<Event> getDetailedEvent(int eventID) async {
  Map<String, dynamic> input = {"id": eventID};

  Event event = await makePostRequest(
      PHPFunction.getDetailedEvent, input, EventBuilder());

  return event;
}

/// Create a new event with the given owner [userEmail], [title], [description],
/// [location], [time], number of [slots], and [category].
Future<Event> createEvent(
    String userEmail,
    String title,
    String description,
    String location,
    String time,
    int slots,
    String category,
    String subCat) async {
  Map<String, dynamic> input = {
    "email": userEmail,
    "title": title,
    "description": description,
    "location": location,
    "time": time,
    "slots": slots,
    "category": category,
    "subcategory": subCat
  };

  Event event =
      await makePostRequest(PHPFunction.createEvent, input, EventBuilder());

  return event;
}

/// Update the event with ID [eventID] with the given [title], [description],
/// [location], [time], number of [slots], and [category].
Future<Event> updateEvent(
    int eventID,
    String title,
    String description,
    String location,
    String time,
    int slots,
    String category,
    String subCat) async {
  Map<String, dynamic> input = {
    "id": eventID,
    "title": title,
    "description": description,
    "location": location,
    "time": time,
    "slots": slots,
    "category": category,
    "subcategory": subCat
  };

  Event event =
      await makePostRequest(PHPFunction.updateEvent, input, EventBuilder());

  return event;
}

/// Add the user with email [userEmail] to the event with ID [eventID], with
/// a given [comment]. Will update the existing join comment if the user has
/// already joined the event. Returns nothing on success, throws an exception
/// on failure.
Future<void> joinEvent(String userEmail, int eventID, String comment) async {
  Map<String, dynamic> input = {
    "email": userEmail,
    "id": eventID,
    "comment": comment
  };

  await makeVoidPostRequest(PHPFunction.joinEvent, input);
}

/// Remove the user with email [userEmail] from the event with ID [eventID]
/// Returns nothing on success, throws an exception on failure.
Future<void> leaveEvent(String userEmail, int eventID) async {
  Map<String, dynamic> input = {"email": userEmail, "id": eventID};

  await makeVoidPostRequest(PHPFunction.leaveEvent, input);
}

/// Get the list of users signed up for the event with ID [eventID]. Throws
/// an exception on failure
Future<List<ForeignUser>> getSignedUpUsers(int eventID) async {
  Map<String, dynamic> input = {"id": eventID};

  List<ForeignUser> users = await makeListPostRequest(
      PHPFunction.getEventUsers, input, ForeignUserBuilder());

  return users;
}

/// Get the list of events that the user with the given [email] created. Throws
/// an exception on failure
Future<List<Event>> getMyEvents(String email) async {
  Map<String, dynamic> input = {"email": email};

  List<Event> events =
      await makeListPostRequest(PHPFunction.getMyEvents, input, EventBuilder());

  return events;
}

/// Get the list of events that the user with the given [email] has joined.
/// Throws an exception on failure
Future<List<Event>> getJoinedEvents(String email) async {
  Map<String, dynamic> input = {"email": email};

  List<Event> events = await makeListPostRequest(
      PHPFunction.getJoinedEvents, input, EventBuilder());

  return events;
}

/// Update the profile information for the user with email [email], setting the
/// [introduction] and [additionalContact] fields. Throws an exception on
/// failure
Future<CurrentUser> updateProfile(
    String email, String introduction, String additionalContact) async {
  Map<String, dynamic> input = {
    "email": email,
    "introduction": introduction,
    "additional_contact": additionalContact
  };

  CurrentUser user = await makePostRequest(
      PHPFunction.updateProfile, input, CurrentUserBuilder());

  return user;
}

/// Report an Event with the [userEmail], reporting the event [eventID], with
/// the given [comment]. Will update the existing reporting comment if the user
/// already reported the event. Throws an exception on failure
Future<void> reportEvent(String userEmail, int eventID, String comment) async {
  Map<String, dynamic> input = {
    "email": userEmail,
    "id": eventID,
    "comment": comment
  };

  await makeVoidPostRequest(PHPFunction.reportEvent, input);
}

/// Get the user information associated with the email [userEmail], which is
/// a separate user from the one logged into the app. Throws and exception on
/// failure
Future<ForeignUser> getForeignUser(String userEmail) async {
  Map<String, dynamic> input = {
    "fEmail": userEmail,
  };

  ForeignUser user = await makePostRequest(
      PHPFunction.getForeignUser, input, ForeignUserBuilder());

  return user;
}

/// Delete the event with the id [eventID]. Throws an exception on failure
Future<void> deleteEvent(int eventID) async {
  Map<String, dynamic> input = {"id": eventID};

  await makeVoidPostRequest(PHPFunction.deleteEvent, input);
}

/// Get the list of events that have been reported. Throws an exception on
/// failure
Future<List<Event>> getAllReportedEvents() async {
  Map<String, dynamic> input = {};

  List<Event> events = await makeListPostRequest(
      PHPFunction.getReportedEvent, input, EventBuilder());

  return events;
}

/// Get the list of report comments for the event with ID [eventID]. Throws
/// an exception on failure
Future<List<String>> getReportedComments(int eventID) async {
  Map<String, dynamic> input = {"id": eventID};

  List<String> comments = await makeListPostRequest(
      PHPFunction.getReportedComment, input, CommentBuilder());

  return comments;
}

/// Get the list of notifications sent to the currently logged in user. Throws
/// an exception on failure
Future<List<Notification>> getNotifications() async {
  Map<String, dynamic> input = {};

  List<Notification> notifications = await makeListPostRequest(
      PHPFunction.getUserNotifications, input, NotificationBuilder());

  return notifications;
}
