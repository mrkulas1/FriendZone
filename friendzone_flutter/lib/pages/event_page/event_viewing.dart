import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/global_header.dart';
import 'event_full_view.dart';
import 'package:friendzone_flutter/pages/modules.dart';

class EventViewAllPage extends StatefulWidget {
  const EventViewAllPage({Key? key}) : super(key: key);

  @override
  _EventViewAllPageState createState() => _EventViewAllPageState();
}

class _EventViewAllPageState extends State<EventViewAllPage> {
  Future<List<Event>>? _events;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _events = getAllEvents();
  }

  // Date selector
  Future<void> _selectDate(BuildContext context) async {
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
    return Scaffold(
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
                                title: Text(snapshot.data![index].title),
                                subtitle: Text(
                                    "Where: ${snapshot.data![index].location}\n"
                                    "When: ${snapshot.data![index].time}\n"
                                    "# of Slots: ${snapshot.data![index].slots}"),
                                onTap: () {
                                  Future<Event> detailedEvent =
                                      getDetailedEvent(
                                          snapshot.data![index].id);

                                  globals.makeSnackbar(
                                      context, "Getting Event Details");

                                  detailedEvent.then((value) {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailEventViewPage(
                                                    data: value)));
                                  }).catchError((error) {
                                    globals.makeSnackbar(
                                        context, error.toString());
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
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _events = getAllEvents();
            });
          },
          backgroundColor: globals.friendzoneYellow,
          child: const Icon(Icons.restart_alt)),
    );
  }
}
