import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';

// Search System
class MySearchDelegate extends SearchDelegate<String> {
  // Changing the variables name may be a good idea.
  // Suggestions + initial suggestions
  // ignore: non_constant_identifier_names
  final List<Event> EventList = [];

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
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.alarm, size: 120),
            SizedBox(height: 48),
            Text(
              "NOTHING TO SEE HERE, WILL IMPLEMENT LATER",
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return FutureBuilder<List<Event>>(
        future: getAllEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            EventList.clear();
            for (int i = 0; i < snapshot.data!.length; i++) {
              EventList.add(snapshot.data![i]);
            }
            return Expanded(
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
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
                      globals.makeSnackbar(context, error.toString());
                    });
                  },
                );
              },
            ));
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

      return buildSuggestionSuccess(suggestion);
    }
  }

  Widget buildSuggestionSuccess(List<Event> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          print(suggestions.length);
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
                globals.makeSnackbar(context, error.toString());
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
