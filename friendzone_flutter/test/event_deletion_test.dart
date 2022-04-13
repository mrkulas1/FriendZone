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

// Event deletion is a simple test, it is it either work or it does not.
void main() {
  // Post two testing event and get their id from database.
  late int totalEventSize;
  const int id = 80;
  const int id2 = 81;

  setUpAll(() async {
    totalEventSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);
  });

  test('Delete an event', () async {
    deleteEvent(id);
    int newSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);
    expect(newSize, totalEventSize - 1);
  });

  test('Delete an event that dont exist', () async {
    int oldSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);
    await deleteEvent(1000);
    int newSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);
    expect(oldSize, newSize);
  });

  test('Delete the same event twice', () async {
    int oldSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);
    await deleteEvent(id2);
    await deleteEvent(id2);
    int newSize = int.parse(jsonDecode(
        await runSql("SELECT COUNT(*) AS size FROM Event", true))["size"]);
    expect(oldSize - 1, newSize);
  });
}
