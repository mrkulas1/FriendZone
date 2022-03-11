/// Not currently used in the app
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/make_post_request.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'event_post.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/global_header.dart';
import 'event_full_view.dart';
import 'package:friendzone_flutter/pages/modules.dart';

class DetailEventViewApp extends StatefulWidget {
  const DetailEventViewApp({Key? key}) : super(key: key);

  @override
  _DetailEventViewApp createState() => _DetailEventViewApp();
}

class _DetailEventViewApp extends State<DetailEventViewApp> {
  Future<List<Event>>? _events;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _events = getAllEvents();
  }

  // Date selector
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2111));
    if (picked != null) {
      setState(
        () {
          selectedDate = picked;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: Header(),
        drawer: const CustomDrawer(),
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
                            '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'),
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
              Container(
                child: _events == null
                    ? Container()
                    : FutureBuilder<List<Event>>(
                        future: _events,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                                child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, int index) {
                                return ListTile(
                                  leading: const Icon(FontAwesomeIcons.atom),
                                  title: Text(
                                    snapshot.data![index].title,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "When: ${snapshot.data![index].time}\n"
                                    "Username: ${snapshot.data![index].id}\n"
                                    "Mail: ${snapshot.data![index].userEmail}\n"
                                    "# of Slots: ${snapshot.data![index].slots}\n"
                                    "Location\n"
                                    "${snapshot.data![index].location}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    child: const Text(
                                      "Join",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    onPressed: () {
                                      // Join, and Left
                                    },
                                  ),
                                );
                              },
                            ));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error!}");
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
