import 'dart:async';
import 'dart:convert';

import 'package:friendzone_flutter/models/builders/json_builder.dart';
import 'package:friendzone_flutter/models/builders/json_list_builder.dart';
import 'package:http/http.dart' as http;

const String postPath =
    "https://classdb.it.mtu.edu/cs3141/team3-frien/friendzone_post.php";

/// Make a POST request to a given [functionID]. T is the type that is
/// decoded from the JSON response. U is the JsonBuilder derived class
/// that can build type T from JSON.
///
/// [inputData] is a Map of parameters that will be passed to the POST
/// [errMessage] is the String to print on POST request failure
/// [builder] is an instance of type U used to build the returned object
Future<T> makePostRequest<T, U extends JsonBuilder<T>>(int functionID,
    Map<String, dynamic> inputData, String errMessage, U builder) async {
  // Add the functionID to the inputData
  inputData.putIfAbsent("functionID", () => functionID);

  final response = await http.post(
    Uri.parse(postPath),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(inputData),
  );

  if (response.statusCode == 200) {
    return builder.fromJson(jsonDecode(response.body));
  } else {
    // Handle other status codes?
    throw Exception(errMessage);
  }
}

/// Make a POST request to a given [functionID] that returns a list of objects.
/// T is the type that is decoded from the JSON response. U is the
/// JsonListBuilder derived class that can build type List<T> from JSON.
///
/// [inputData] is a Map of parameters that will be passed to the POST
/// [errMessage] is the String to print on POST request failure
/// [builder] is an instance of type U used to build the returned list
Future<List<T>> makeListPostRequest<T, U extends JsonListBuilder<T>>(
    int functionID,
    Map<String, dynamic> inputData,
    String errMessage,
    U builder) async {
  // Add the functionID to the inputData
  inputData.putIfAbsent("functionID", () => functionID);

  final response = await http.post(
    Uri.parse(postPath),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(inputData),
  );

  if (response.statusCode == 200) {
    return builder.listFromJson(jsonDecode(response.body));
  } else {
    // Handle other status codes?
    throw Exception(errMessage);
  }
}
