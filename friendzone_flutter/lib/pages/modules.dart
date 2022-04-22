import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';

/// This class handles the name searching system on the event_viewing page
class MySearchDelegate extends SearchDelegate<String> {
  // Changing the variables name may be a good idea.
  // Suggestions + initial suggestions
  // ignore: non_constant_identifier_names
  final List<Event> EventList = [];
  List<Event> remaining = [];

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, ''); // Close the search bar if empty
              } else {
                query = ''; // Clear the search bar
                showSuggestions(context);
              }
            },
            icon: const Icon(Icons.clear))
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) => ListView.builder(
        itemCount: remaining.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Future<Event> detailedEvent =
                  getDetailedEvent(remaining[index].id);

              globals.makeSnackbar(context, "Getting Event Details");

              detailedEvent.then((value) {
                ScaffoldMessenger.of(context).clearSnackBars();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailEventViewPage(data: value)));
              }).catchError((error) {
                globals.unifiedErrorCatch(context, error);
              });
            },
            leading: Icon(customIcons(remaining[index].category)),
            title: RichText(
              text: TextSpan(
                text: remaining[index].title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return FutureBuilder<List<Event>>(
        future: getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            EventList.clear();
            remaining.clear();
            // Insert all the event data into the event List
            for (int i = 0; i < snapshot.data!.length; i++) {
              EventList.add(snapshot.data![i]);
              remaining.add(snapshot.data![i]);
            }

            int limit = 15;

            if (snapshot.data!.length < 10) limit = snapshot.data!.length;

            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: limit,
              itemBuilder: (context, int index) {
                return ListTile(
                  leading: const Icon(FontAwesomeIcons.magnifyingGlass),
                  title: Text(snapshot.data![index].title),
                  onTap: () {
                    Future<Event> detailedEvent =
                        getDetailedEvent(snapshot.data![index].id);

                    globals.makeSnackbar(context, "Getting Event Details");

                    detailedEvent.then((value) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailEventViewPage(data: value)));
                    }).catchError((error) {
                      globals.unifiedErrorCatch(context, error);
                    });
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error!}");
          }
          return const CircularProgressIndicator();
        },
      );
    } else {
      final suggestion = EventList.where((sugPl) {
        final sugLower = sugPl.title.toLowerCase();
        final qLower = query.toLowerCase();

        return sugLower.startsWith(qLower);
      }).toList();

      remaining = suggestion;
      return buildSuggestionSuccess(suggestion);
    }
  }

  Widget buildSuggestionSuccess(List<Event> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.title.substring(0, query.length);
          final remainingText = suggestion.title.substring(query.length);
          return ListTile(
            onTap: () {
              Future<Event> detailedEvent = getDetailedEvent(suggestion.id);

              globals.makeSnackbar(context, "Getting Event Details");

              detailedEvent.then((value) {
                ScaffoldMessenger.of(context).clearSnackBars();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailEventViewPage(data: value)));
              }).catchError((error) {
                globals.unifiedErrorCatch(context, error);
              });
            },
            leading: const Icon(FontAwesomeIcons.magnifyingGlass),
            // title: Text(suggestion)
            title: RichText(
                text: TextSpan(
              text: queryText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: remainingText,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ],
            )),
          );
        },
      );
}

IconData customIcons(String catigory) {
  IconData data = FontAwesomeIcons.atom;

  if (catigory == "Academic") {
    data = FontAwesomeIcons.school;
  } else if (catigory == "Active") {
    data = FontAwesomeIcons.futbol;
  } else if (catigory == "Carpool") {
    data = FontAwesomeIcons.car;
  } else if (catigory == "Clubs") {
    data = FontAwesomeIcons.puzzlePiece;
  } else if (catigory == "Creative") {
    data = FontAwesomeIcons.brush;
  } else if (catigory == "Gaming") {
    data = FontAwesomeIcons.gamepad;
  } else if (catigory == "Volunteer") {
    data = FontAwesomeIcons.handshake;
  }

  return data;
}
