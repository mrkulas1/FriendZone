import 'dart:convert';
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';
import 'package:http/http.dart' as http;

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';

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

// !! GO COMMENT OUT SOME CODE ON THE FILE make_post_request.dart. Under the db_comm directory.

void main() {
  late int specificJoinSize;
  late int eventSlotSize;
  const int id = 58; // Change here for testing different event.

  /// Set up the tables from the test data, and backup the existing tables
  setUpAll(() async {
    specificJoinSize = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    eventSlotSize = int.parse(jsonDecode(await runSql(
        "SELECT slots AS size FROM Event WHERE id=$id", true))["size"]);
    // Backup just to make sure nothing fishy happne
    await runSql("CREATE TABLE Join_Backup AS SELECT * FROM Joins", false);
  });

  test('Set Up', () async {
    // Reset
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    expect(specificJoinSize, 0);
    // TEMP USER;
    for (int i = 0; i < eventSlotSize + 1; i++) {
      await register("$i@mtu.edu", "1", "T", " ", " ");
    }
  });

  test('Join and Leave 1 time', () async {
    // Reset
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    await joinEvent("1@mtu.edu", id, "");
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 1);
    await leaveEvent("1@mtu.edu", id);
    result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 0);
  });

  test('Join 2 and Leave 1 time', () async {
    // Reset
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    await joinEvent("1@mtu.edu", id, "");
    await joinEvent("2@mtu.edu", id, "");
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 2);
    await leaveEvent("1@mtu.edu", id);
    result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 1);
  });

  test('Join and Leave MAX TIME', () async {
    // Reset
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    for (var i = 0; i < eventSlotSize; i++) {
      await joinEvent("$i@mtu.edu", id, "");
    }

    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 5);

    for (var i = 0; i < eventSlotSize; i++) {
      await leaveEvent("$i@mtu.edu", id);
    }
    result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 0);
  });

  test("Leave item with no id", () async {
    // Reset
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    await leaveEvent("1@mtu.edu", id);
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 0);
  });

  test("JOIN MAX + 1", () async {
    // Reset
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    for (var i = 0; i < eventSlotSize + 1; i++) {
      await joinEvent("$i@mtu.edu", id, "");
    }
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 5);
  });

  //Reset the tables to their initial state
  tearDownAll(() async {
    // Remove the test data
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    for (int i = 0; i < eventSlotSize + 1; i++) {
      await runSql("DELETE FROM User where email = '$i@mtu.edu'", false);
    }
  });
}
