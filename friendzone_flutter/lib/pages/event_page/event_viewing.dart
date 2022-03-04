import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/make_post_request.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'event_post.dart';
import 'package:friendzone_flutter/globals.dart' as globals;

class EventViewApp extends StatefulWidget {
  const EventViewApp({Key? key}) : super(key: key);

  @override
  _EventViewApp createState() => _EventViewApp();
}

class _EventViewApp extends State<EventViewApp> {
  // TODO: Convert to LIST

  DateTime selectedDate = DateTime.now();
  // Date selector
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2111));
    if (picked != null)
      setState(
        () {
          selectedDate = picked;
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Friend Zone';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFFFCC00)),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  // DIRECT TO ACCOUNT INFORMATION PAGE
                },
                icon: const Icon(
                  FontAwesomeIcons.user,
                  color: Color(0xFFFFCC00),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.black,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                // We can add a logo/picture here for decoration
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                ),
                child: Text(''),
              ),
              ListTile(
                textColor: const Color(0xFFFFCC00),
                title: const Text('Home'),
                onTap: () {
                  // TAKE ME HOMEEEEEEEEEEEEEEEEEEEEE
                  Navigator.pop(context);
                },
              ),
              ListTile(
                textColor: const Color(0xFFFFCC00),
                title: const Text('Post Event'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const EventPostPage()),
                    ),
                  );
                },
              ),
              ListTile(
                textColor: const Color(0xFFFFCC00),
                title: const Text('Do something'),
                onTap: () {
                  // Do something
                },
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFFDCDCDC), // Background color
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    // Row of search bottom and search text
                    children: [
                      IconButton(
                        onPressed: () {
                          showSearch(
                              context: context, delegate: MySearchDelegate());
                        },
                        icon: const Icon(
                          Icons.search,
                          semanticLabel: "Search",
                        ),
                      ),
                      const Text('Search'),
                    ],
                  ),
                  Row(
                    // TODO: Might be a good idea to add some arrow by move the date
                    // Date selector
                    children: [
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                          // TODO: Honestly could use this as the filter for dates, IDK
                        },
                        child: Text(
                            '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Filter'),
                      IconButton(
                          onPressed: () {
                            // Add some stuff here for filter list
                          },
                          icon: const Icon(FontAwesomeIcons.filter)),
                    ],
                  ),
                ],
              ),
              FutureBuilder<List<Event>>(
                future: getAllEvents(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: Text("Loading..."));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, int index) {
                        return ListTile(
                          leading: const Icon(FontAwesomeIcons.atom),
                          title: Text(snapshot.data![index].title),
                          subtitle: Text(snapshot.data![index].time +
                              "\n  ${snapshot.data![index].slots}"),
                          onTap: () {
                            // TODO: Get to the detail Page
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate<String> {
  // Changing the variables name may be a good idea.
  // Suggestions + initial suggestions
  final pr = ['Skiing', 'Soccer', 'Movie', 'Study', 'Hiking'];
  // ignore: non_constant_identifier_names
  final sug_pr = ['Soccer', 'Movie'];

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
          children: [
            const Icon(Icons.abc, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: const TextStyle(
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
    // Changing some of the variable name may be a good idea.
    final suggestion = query.isEmpty
        ? sug_pr
        : pr.where((sugPl) {
            final sugLower = sugPl.toLowerCase();
            final qLower = query.toLowerCase();

            return sugLower.startsWith(qLower);
          }).toList();

    return buildSuggestionSuccess(suggestion);
  }

  Widget buildSuggestionSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              showResults(context);
            },
            leading: const Icon(Icons.abc),
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
