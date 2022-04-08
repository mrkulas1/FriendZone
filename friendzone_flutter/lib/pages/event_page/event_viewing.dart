import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';
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
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool fromPicked = false;
  bool toPicked = false;
  List<Event> newEvents = [];
  final TextEditingController _nameControl = TextEditingController();

  @override
  void initState() {
    super.initState();

    _events = getAllEvents();
    _nameControl.text = "";
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

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? pickedTo = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2111));
    if (pickedTo != null) {
      setState(() {
        toPicked = true;
        toDate = pickedTo;
      });
    }
  }

  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime? pickedFrom = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2019, 1),
        lastDate: DateTime(2111));
    if (pickedFrom != null) {
      setState(() {
        fromPicked = true;
        fromDate = pickedFrom;
      });
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
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
                              IconData data = FontAwesomeIcons.atom;
                              // TODO: Change when enum is finish
                              // ignore: unrelated_type_equality_checks
                              if (snapshot.data![index].category ==
                                  "Academic") {
                                data = FontAwesomeIcons.graduationCap;
                              } else if (snapshot.data![index].category ==
                                  "Active") {
                                data = FontAwesomeIcons.futbol;
                              } else if (snapshot.data![index].category ==
                                  "Carpool") {
                                data = FontAwesomeIcons.car;
                              } else if (snapshot.data![index].category ==
                                  "Clubs") {
                                data = FontAwesomeIcons.puzzlePiece;
                              } else if (snapshot.data![index].category ==
                                  "Creative") {
                                data = FontAwesomeIcons.brush;
                              } else if (snapshot.data![index].category ==
                                  "Gaming") {
                                data = FontAwesomeIcons.dAndD;
                              } else if (snapshot.data![index].category ==
                                  "Volunteer") {
                                data = FontAwesomeIcons.handshake;
                              }
                              return ListTile(
                                leading: Icon(data),
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
                                    globals.unifiedErrorCatch(context, error);
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

  Widget _buildPopupDialog(BuildContext context) {
    int? selectedValue = 1;
    return AlertDialog(
      insetPadding: const EdgeInsets.all(15),
      title: Container(
        height: 50,
        width: 200,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        color: Colors.black,
        child: const Text("Filter Events",
            textAlign: TextAlign.center,
            style: TextStyle(color: globals.friendzoneYellow, fontSize: 25)),
      ),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              key: const Key("Filter_Text"),
              controller: _nameControl,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Event Name",
                  hintText: "Event Name Here"),
              autofocus: false,
            ),
            Row(
              children: [
                const Text("Select Event Type: "),
                DropdownButton(
                    value: selectedValue,
                    alignment: Alignment.center,
                    items: const [
                      DropdownMenuItem(
                        child: Text("Friend 1"),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("Friend 2"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                        child: Text("Friend 3"),
                        value: 3,
                      ),
                    ],
                    onChanged: (int? value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    hint: Text("Select Event Category"))
              ],
            ),
            /*Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: */
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Events After: "),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectDateFrom(context).then(((value) => setState(() {})));
                    //fromDate = fromDate;
                  });
                },
                child:
                    Text('${fromDate.month}/${fromDate.day}/${fromDate.year}'),
                key: const Key("fromDate"),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      fromDate = DateTime.now();
                      fromPicked = false;
                    });
                  },
                  icon: const Icon(FontAwesomeIcons.xmark, color: Colors.red)),
            ]) /*)*/,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Events Before: "),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectDateTo(context).then(((value) => setState(() {})));
                    //toDate = toDate;
                  });
                },
                child: Text('${toDate.month}/${toDate.day}/${toDate.year}'),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      toDate = DateTime.now();
                      toPicked = false;
                    });
                  },
                  icon: const Icon(FontAwesomeIcons.xmark, color: Colors.red)),
              //FIgure Out Tomorrow
            ]),
          ],
        );
      }),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  //Key("Filter_Text").
                  setState(() {
                    fromPicked = false;
                    toPicked = false;
                    toDate = DateTime.now();
                    fromDate = DateTime.now();
                    _events = getAllEvents();
                    _nameControl.text = "";
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      globals.friendzoneYellow),
                ),
                child: const Text("Reset Filter")),
            ElevatedButton(
              onPressed: () {
                //Filter Events by whatever Here

                _events = getAllEvents();
                newEvents = [];
                List<Event> events = [];

                String eventName = _nameControl.text;

                _events?.then((events) {
                  for (Event e in events) {
                    bool validEvent = true;
                    if (!e.title
                        .toLowerCase()
                        .contains(eventName.toLowerCase())) {
                      validEvent = false;
                    }

                    if (e.time.length > 5 && (toPicked || fromPicked)) {
                      if (toPicked &&
                          (!DateTime.parse(e.time).isBefore(toDate) &&
                              DateTime.parse(e.time).day != toDate.day)) {
                        validEvent = false;
                      }
                      if (fromPicked &&
                          !DateTime.parse(e.time).isAfter(fromDate)) {
                        validEvent = false;
                      }
                    } else if (e.time.length <= 5 && (toPicked || fromPicked)) {
                      validEvent = false;
                    }

                    if (validEvent) {
                      newEvents.add(e);
                      setState(() {
                        _events = Future.value(newEvents);
                      });
                    }
                  }
                });

                setState(() {
                  _events = Future.value(newEvents);
                  setState(() {
                    _events = Future.value(newEvents);
                  });
                });

                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(globals.friendzoneYellow),
              ),
              child: Text(
                "Search",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(globals.friendzoneYellow),
              ),
              child: const Text("Cancel",
                  style: TextStyle(color: Color.fromARGB(255, 254, 0, 0))),
            ),
          ],
        )
      ],
    );
  }
}
