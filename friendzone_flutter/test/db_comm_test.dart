import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/auth_result.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/models/builders/auth_result_builder.dart';
import 'package:friendzone_flutter/models/builders/event_builder.dart';
import 'package:friendzone_flutter/models/builders/current_user_builder.dart';

Future<String> runSql(String query, bool fetch) async {
  final response = await http.post(
    Uri.parse("https://classdb.it.mtu.edu/cs3141/team3-frien/tester.php"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      "query": query,
      "fetch": fetch,
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception(response.body);
  }
}

void main() {
  late int autoInc;
  late int origUserSize;
  late int origEventSize;

  const int userTestSize = 8;
  const int eventTestSize = 5;

  /// Set up the tables from the test data, and backup the existing tables
  setUpAll(() async {
    autoInc = int.parse(jsonDecode(
        await runSql("SELECT MAX(id) AS inc FROM Event", true))["inc"]);
    autoInc++;

    print(autoInc);

    origUserSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM User", true))["size"]);

    origEventSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);

    // Backup everything first to avoid any foreign key cascade deletes
    await runSql("CREATE TABLE User_Backup AS SELECT * FROM User", false);
    await runSql("CREATE TABLE Event_Backup AS SELECT * FROM Event", false);

    await runSql("DELETE FROM User WHERE 1=1", false);
    await runSql("DELETE FROM Event WHERE 1=1", false);

    // Move the test tables in
    await runSql("INSERT INTO User SELECT * FROM User_Test", false);
    await runSql("INSERT INTO Event SELECT * FROM Event_Test", false);
  });

  /// Verify that the setup runs as expected, and properly copies over the table
  /// This gives confidence that the other tests won't fail due to a bad setUp
  /// method.
  // TODO: Find a better way to track the sizes of the tables
  test('Test Setup', () async {
    int sizeUserBackup = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM User_Backup", true))["size"]);
    int sizeUser = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM User", true))["size"]);
    int sizeEventBackup = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Event_Backup", true))["size"]);
    int sizeEvent = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);

    expect(sizeUserBackup, origUserSize);
    expect(sizeUser, userTestSize);

    expect(sizeEventBackup, origEventSize);
    expect(sizeEvent, eventTestSize);
  });

  /// Test each outcome of the authenticate, except for internal PHP error,
  /// since that cannot be predictably caused
  test('Test Authenticate', () async {
    AuthResult result;

    // Case 1: Provide an email that no users have
    result = await authenticate("none@mtu.edu", "password");

    expect(result.status, AuthStatus.noUser);

    // Case 2: Provide an existing email, but incorrect password
    result = await authenticate("CS3141Admin@mtu.edu", "12345");

    expect(result.status, AuthStatus.badCredentials);

    // Case 3: Provide a correct email / password
    result = await authenticate("CS3141Admin@mtu.edu", "admin");

    expect(result.status, AuthStatus.valid);

    // Check that the user was pulled correctly on valid login
    CurrentUser user = result.getUser();

    expect(user.email, "CS3141Admin@mtu.edu");
    expect(user.name, "admin");
    expect(user.introduction, "");
    expect(user.contact, "1 (420) 666 - 6969");
  });

  /// Test that registering a user adds a row to the user table,
  /// and that the new user is pulled correctly into the app
  test('Test Register', () async {
    CurrentUser user;

    // Check that exception is thrown when a user already exists
    try {
      user = await register(
          "CS3141Admin@mtu.edu", "password", "admin", "test", "test");
      fail("No Exception Thrown");
    } catch (e) {
      expect(e, isA<Exception>());
      expect(e.toString(),
          "Exception: A user with this email is already registered. Try logging in");
    }

    // Make a new user
    user = await register(
        "new@mtu.edu", "123456789", "New User", "Hello", "phone");

    // Check that user is pulled correctly
    expect(user.email, "new@mtu.edu");
    expect(user.name, "New User");
    expect(user.introduction, "Hello");
    expect(user.contact, "phone");

    // Check that database table size went up
    int sizeUser = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM User", true))["size"]);
    expect(sizeUser, userTestSize + 1);
  });

  test('Test Get All Events', () async {
    List<Event> events;

    events = await getAllEvents();

    // Check size of list
    expect(events.length, eventTestSize);

    // Assemble all the IDs
    Set<int> idSet = {};
    for (Event element in events) {
      idSet.add(element.id);
    }

    // Check that all expected IDs are in the list
    expect(
        idSet.containsAll(
            <int>[123123123, 234324245, 123333333, 666666645, 132523546]),
        true);
  });

  test('Test Get Detailed Event', () async {
    Event event;

    // Try to get an event that doesn't exist, check for exception
    try {
      event = await getDetailedEvent(0);
      fail("No Exception Thrown");
    } catch (e) {
      expect(e, isA<Exception>());
      expect(e.toString(), "Exception: Requested event was not found.");
    }
    event = await getDetailedEvent(123123123);

    // Check that all the fields of the event are retrieved
    expect(event.id, 123123123);
    expect(event.userEmail, "aelaest@mtu.edu");
    expect(event.title, "Fun With FriendZone");
    expect(event.description, "testing spicy event stuff");
    expect(event.time, "2021-03-23 00:00:00");
    expect(event.location, "Somewhere");
    expect(event.slots, 23);
    expect(event.category, 6);
    expect(event.reported, false);
    expect(event.dateCreated, "2021-03-23 12:23:04");
  });

  /// Create a new event, check that all the data reaches the app correctly,
  /// and that the event table increases in size
  test('Test Create Event', () async {
    Event event = await createEvent("CS3141Admin@mtu.edu", "New Event",
        "New Event Description", "Place", "", 5, 0);

    expect(event.userEmail, "CS3141Admin@mtu.edu");
    expect(event.title, "New Event");
    expect(event.description, "New Event Description");
    expect(event.location, "Place");
    expect(event.slots, 5);

    // Check that database row was added
    int sizeEvent = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);

    expect(sizeEvent, eventTestSize + 1);
  });

  /// Update an existing event, check that new data reaches the app correctly
  test('Test Update Event', () async {
    Event event;
    // Try to update an event that doesn't exist, check for exception
    try {
      event = await updateEvent(0, "", "", "", "", 0, 0);
      fail("No Exception Thrown");
    } catch (e) {
      expect(e, isA<Exception>());
      expect(e.toString(), "Exception: No event with the provided ID exists");
    }

    event = await updateEvent(
        123123123, "Fun2", "testing2", "Somewhere2", "2021-03-23", 8, 1);

    expect(event.id, 123123123);
    expect(event.userEmail, "aelaest@mtu.edu");
    expect(event.title, "Fun2");
    expect(event.description, "testing2");
    expect(event.location, "Somewhere2");
    expect(event.time, "2021-03-23 00:00:00");
    expect(event.slots, 8);
    expect(event.category, 1);
  });

  /// Reset the tables to their initial state
  tearDownAll(() async {
    // Remove the test data
    await runSql("DELETE FROM User WHERE 1=1", false);
    await runSql("DELETE FROM Event WHERE 1=1", false);

    // Restore User first to not violate foreign key
    await runSql("INSERT INTO User SELECT * FROM User_Backup", false);
    await runSql("INSERT INTO Event SELECT * FROM Event_Backup", false);

    await runSql("ALTER TABLE Event AUTO_INCREMENT = $autoInc", false);

    await runSql("DROP TABLE User_Backup", false);
    await runSql("DROP TABLE Event_Backup", false);
  });
}
