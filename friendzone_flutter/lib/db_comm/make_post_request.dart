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

  joinEvent
}

// Path for all POST requests
const String postPath =
    "https://classdb.it.mtu.edu/cs3141/team3-frien/friendzone_post.php";

// List of status codes that can be returned by the PHP
const int phpSuccessCode = 200; // Expected result will be available
const int phpNotFoundCode = 404; // Requested data not in database
const int phpAlreadyThereCode = 409; // Data to add already exists in database
const int phpInternalErrorCode = 202;

/// Create an error messages map and optionally specify specific error messages
/// [notFoundMessage] is printed on response 404
/// [alreadyThereMessage] is printed on response 409
/// [internalErrorMessage] is printed on response 500
Map<int, String> buildErrorMessages(
    {String notFoundMessage = "Requested data not in database",
    String alreadyThereMessage = "Data to add already exists in database",
    String internalErrorMessage = "PHP Error occurred"}) {
  return <int, String>{
    phpNotFoundCode: notFoundMessage,
    phpAlreadyThereCode: alreadyThereMessage,
    phpInternalErrorCode: internalErrorMessage
  };
}

/// Make a POST request to a given [functionID]. T is the type that is
/// decoded from the JSON response. U is the JsonBuilder derived class
/// that can build type T from JSON.
///
/// [inputData] is a Map of parameters that will be passed to the POST
/// [errMessages] is the Map of messages to print on POST request failure,
/// depending on the response code (thrown as exception)
/// [builder] is an instance of type U used to build the returned object
Future<T> makePostRequest<T, U extends JsonBuilder<T>>(
    PHPFunction functionID,
    Map<String, dynamic> inputData,
    Map<int, String> errMessages,
    U builder) async {
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
      return builder.fromJson(jsonDecode(response.body));
    case phpNotFoundCode:
      throw Exception(
          errMessages[phpNotFoundCode] ?? "Requested data not in database");
    case phpAlreadyThereCode:
      throw Exception(errMessages[phpAlreadyThereCode] ??
          "Data to add already exists in database");
    case phpInternalErrorCode:
      throw Exception(
          errMessages[phpInternalErrorCode] ?? "PHP Error occurred");
    default:
      throw Exception("Unexpected error occurred");
  }
}

/// Make a POST request to a given [functionID] that returns a list of objects.
/// T is the type that is decoded from the JSON response. U is the
/// JsonListBuilder derived class that can build type List<T> from JSON.
///
/// [inputData] is a Map of parameters that will be passed to the POST
/// [errMessages] is the Map of messages to print on POST request failure,
/// depending on the response code (thrown as exception)
/// [builder] is an instance of type U used to build the returned list
Future<List<T>> makeListPostRequest<T, U extends JsonListBuilder<T>>(
    PHPFunction functionID,
    Map<String, dynamic> inputData,
    Map<int, String> errMessages,
    U builder) async {
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
      return builder.listFromJson(jsonDecode(response.body));
    case phpNotFoundCode:
      throw Exception(
          errMessages[phpNotFoundCode] ?? "Requested data not in database");
    case phpAlreadyThereCode:
      throw Exception(errMessages[phpAlreadyThereCode] ??
          "Data to add already exists in database");
    case phpInternalErrorCode:
      throw Exception(
          errMessages[phpInternalErrorCode] ?? "PHP Error occurred");
    default:
      throw Exception("""Unexpected error occurred. 
          Check your internet connection and try again.""");
  }
}
