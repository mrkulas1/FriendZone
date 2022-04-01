import 'dart:async';
import 'dart:convert';

import 'package:friendzone_flutter/models/builders/json_builder.dart';
import 'package:friendzone_flutter/models/builders/json_list_builder.dart';
import 'package:http/http.dart' as http;

/// Enum to track the IDs of all PHP functions that can be called.
/// MAKE SURE THIS ENUM IS ALWAYS IN THE SAME ORDER AS THE ONE IN
/// friendzone_post.php!!
enum PHPFunction {
  auth,
  getCurrentUser,
  createUser,

  getAllEvents,
  getDetailedEvent,
  createEvent,
  updateEvent,

  joinEvent,
  leaveEvent,

  getEventUsers,
  getMyEvents,
  getJoinedEvents,

  updateProfile,

  reportEvent
}

// Path for all POST requests
const String postPath =
    "https://classdb.it.mtu.edu/cs3141/team3-frien/friendzone_post.php";

// List of status codes that can be returned by the PHP
const int phpSuccessCode = 200; // Expected result will be available
const int phpInternalErrorCode = 202;

/// Make a POST request to a given [functionID]. T is the type that is
/// decoded from the JSON response. U is the JsonBuilder derived class
/// that can build type T from JSON.
///
/// [inputData] is a Map of parameters that will be passed to the POST
/// [builder] is an instance of type U used to build the returned object
Future<T> makePostRequest<T, U extends JsonBuilder<T>>(
    PHPFunction functionID, Map<String, dynamic> inputData, U builder) async {
  // Add the functionID to the inputData
  inputData.putIfAbsent("functionID", () => functionID.index);

  final response = await http.post(
    Uri.parse(postPath),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(inputData),
  );

  switch (response.statusCode) {
    case phpSuccessCode:
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey("error")) {
        throw Exception(json["error"]);
      }

      return builder.fromJson(json);
    case phpInternalErrorCode:
      throw Exception("Internal PHP Error occurred");
    default:
      throw Exception("Unexpected error occurred");
  }
}

/// Make a POST request to a given [functionID] that returns a list of objects.
/// T is the type that is decoded from the JSON response. U is the
/// JsonListBuilder derived class that can build type List<T> from JSON.
///
/// [inputData] is a Map of parameters that will be passed to the POST
/// [builder] is an instance of type U used to build the returned list
Future<List<T>> makeListPostRequest<T, U extends JsonListBuilder<T>>(
    PHPFunction functionID, Map<String, dynamic> inputData, U builder) async {
  // Add the functionID to the inputData
  inputData.putIfAbsent("functionID", () => functionID.index);

  final response = await http.post(
    Uri.parse(postPath),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(inputData),
  );

  switch (response.statusCode) {
    case phpSuccessCode:
      // Kind of hacky, but fixes the type mismatch error
      // TODO: Make code less gross
      try {
        List<dynamic> json = jsonDecode(response.body);

        if (json.isEmpty) {
          return [];
        }

        if (json[0].containsKey("error")) {
          throw Exception(json[0]["error"]);
        }

        return builder.listFromJson(jsonDecode(response.body));
      } catch (e) {
        Map<String, dynamic> json = jsonDecode(response.body);

        if (json.containsKey("error")) {
          throw Exception(json["error"]);
        } else {
          rethrow;
        }
      }
    case phpInternalErrorCode:
      throw Exception("PHP Error occurred");
    default:
      throw Exception("Unexpected error occurred");
  }
}

/// Use for requests where no data is returned. Make a POST request to a given
/// [functionID] with the input [inputData].
Future<void> makeVoidPostRequest(
    PHPFunction functionID, Map<String, dynamic> inputData) async {
  inputData.putIfAbsent("functionID", () => functionID.index);

  final response = await http.post(
    Uri.parse(postPath),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(inputData),
  );

  // Uncomment this when testing join and leave because JSON NOT WORKING PROPERLY
  // return;
  // COMMENT THE BELOW CODE OUT WHEN TESTING.
  switch (response.statusCode) {
    case phpSuccessCode:
      Map<String, dynamic> json = jsonDecode(response.body);
      if (json.containsKey("error")) {
        throw Exception(json["error"]);
      }
      return;

    case phpInternalErrorCode:
      throw Exception("PHP Error occurred");
    default:
      throw Exception("Unexpected error occurred");
  }
}
