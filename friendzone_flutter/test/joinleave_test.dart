import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
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

void main() {
  late int specificJoinSize;
  late int eventSlotSize;
  const int id = 58; // Change here for testing different event.
  // Future<List<ForeignUser>> _signedUp;
  // List<ForeignUser> UserList;

  /// Set up the tables from the test data, and backup the existing tables
  setUpAll(() async {
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    specificJoinSize = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    eventSlotSize = int.parse(jsonDecode(await runSql(
        "SELECT slots AS size FROM Event WHERE id=$id", true))["size"]);
    // Backup just to make sure nothing fishy happne
    await runSql("CREATE TABLE Join_Backup AS SELECT * FROM Joins", false);
  });

  test('Set Up', () async {
    expect(specificJoinSize, 0);
  });

  test('Join and Leave 1 time', () async {
    // Reset the join
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    joinEvent("1@mtu.edu", id, "");
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 1);
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 1);
    leaveEvent("1@mtu.edu", id);
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 0);
    result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 0);
  });

  test('Join 2 and Leave 1 time', () async {
    joinEvent("1@mtu.edu", id, "");
    joinEvent("2@mtu.edu", id, "");
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 2);
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 2);
    leaveEvent("1@mtu.edu", id);
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 0);
    result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 1);
    // Reset the join
    await runSql("DELETE FROM Joins WHERE id=$id", false);
  });

  test('Join and Leave MAX TIME', () async {
    // Reset the join
    await runSql("DELETE FROM Joins WHERE id=$id", false);

    for (var i = 0; i < eventSlotSize; i++) {
      joinEvent("$i@mtu.edu", id, "");
    }

    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 5);
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 5);

    for (var i = 0; i < eventSlotSize; i++) {
      leaveEvent("$i@mtu.edu", id);
    }
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 0);
    result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 0);
  });

  test("Leave item with no id", () async {
    // Reset the join
    await runSql("DELETE FROM Joins WHERE id=$id", false);
    leaveEvent("1@mtu.edu", id);
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 0);
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 0);
  });

  test("JOIN MAX + 1", () async {
    // Reset the join
    await runSql("DELETE FROM Joins WHERE id=$id", false);
    for (var i = 0; i < eventSlotSize + 1; i++) {
      joinEvent("$i@mtu.edu", id, "");
    }
    // _signedUp = getSignedUpUsers(id);
    // UserList = await _signedUp;
    // expect(UserList.length, 5);
    int result = int.parse(jsonDecode(await runSql(
        "SELECT COUNT(*) AS size FROM Joins WHERE id=$id", true))["size"]);
    expect(result, 5);
  });

  /// Reset the tables to their initial state
  // tearDownAll(() async {
  //   // Remove the test data
  //   await runSql("DELETE FROM Joins WHERE id=$id", false);

  //   // Restore User first to not violate foreign key
  //   await runSql("INSERT IGNORE INTO Joins SELECT * FROM Join_Backup", false);

  //   await runSql("DROP TABLE Join_Backup", false);
  // });
}
