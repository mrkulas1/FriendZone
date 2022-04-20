import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/pages/modules.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  Future<List<Event>>? _events;
  DateTime selectedDate = DateTime.now();
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  bool fromPicked = false;
  bool toPicked = false;
  List<Event> newEvents = [];
  final TextEditingController _nameControl = TextEditingController();

  final List<String> generalcat = [
    'Academic',
    'Active',
    'Carpool',
    'Clubs',
    'Creative',
    'Gaming',
    'Volunteer',
    'Other'
  ];
  final List<String> academicsubcat = [
    'Study Group',
    'Homework',
    'Tutoring',
    'Other'
  ];
  final List<String> activesubcat = [
    'Winter Sports',
    'Water Sports',
    'Racquet Sports',
    'Team Sports',
    'Other'
  ];
  final List<String> carpoolsubcat = [
    'Short Distances',
    'Long Distances',
    'Other'
  ];
  final List<String> clubsSubcat = [];
  final List<String> creativeSubcat = ['Art', 'Music', 'Other'];
  final List<String> gamingSubcat = [
    'Video Games',
    'Board Games',
    'Card Games',
    'Other'
  ];
  final List<String> volunteerSubcat = [];
  List<String> subcat = [];
  String? selectCat;
  String? selectSubCat;

  @override
  void initState() {
    super.initState();

    _events = getAllReportedEvent();
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
          children: <Widget>[
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
                              return ListTile(
                                  leading: Icon(customIcons(
                                      snapshot.data![index].category)),
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
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Future<List<String>>
                                                reportedComments =
                                                getReportedComment(
                                                    snapshot.data![index].id);

                                            globals.makeSnackbar(
                                                context, "Getting Comments");

                                            reportedComments.then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .clearSnackBars();
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                        title: const Text(
                                                            "Reports"),
                                                        content: SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              2,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2,
                                                          child:
                                                              ListView.builder(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .vertical,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemCount: value
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          int index) {
                                                                    return ListTile(
                                                                        title: Text(
                                                                            value[index]));
                                                                  }),
                                                        ));
                                                  });
                                            }).catchError((error) {
                                              globals.unifiedErrorCatch(
                                                  context, error);
                                            });
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    globals.friendzoneYellow),
                                          ),
                                          child: const Text(
                                            "View Reports",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            FontAwesomeIcons.xmark,
                                            color: Colors.black,
                                          ),
                                          //color: globals.friendzoneYellow,
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildDeleteDialogue(
                                                      context,
                                                      snapshot
                                                          .data![index].title,
                                                      snapshot.data![index].id),
                                            );
                                          },
                                        )
                                      ]));
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
              _events = getAllReportedEvent();
            });
          },
          backgroundColor: globals.friendzoneYellow,
          child: const Icon(Icons.restart_alt)),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
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
                DropdownButton<String>(
                    value: selectCat,
                    alignment: Alignment.center,
                    items: generalcat.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      onChangedCallback(value, setState);
                    },
                    hint: const Text("Select Event Category"))
              ],
            ),
            Row(
              children: [
                const Text("Select Subcategory: "),
                DropdownButton<String>(
                  hint: const Text('Subcategory'),
                  value: selectSubCat,
                  items: subcat.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? subcat) {
                    setState(() {
                      selectSubCat = subcat;
                    });
                  },
                )
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
                    _events = getAllReportedEvent();
                    _nameControl.text = "";
                    selectCat = null;
                    selectSubCat = null;
                  });
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      globals.friendzoneYellow),
                ),
                child: const Text("Reset Filter")),
            ElevatedButton(
              onPressed: () {
                //Filter Events by whatever Here

                _events = getAllReportedEvent();
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

                    if (selectCat != null) {
                      if (e.category != selectCat) {
                        validEvent = false;
                      }

                      if (e.category == selectCat &&
                          e.subCat != selectSubCat &&
                          selectSubCat != null) {
                        validEvent = false;
                      }
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

  void onChangedCallback(String? generalcat, StateSetter setState) {
    if (generalcat == 'Academic') {
      setState(() {
        selectCat = "Academic";
        subcat = academicsubcat;
        selectSubCat = null;
      });
    } else if (generalcat == 'Active') {
      setState(() {
        selectCat = "Active";
        subcat = activesubcat;
        selectSubCat = null;
      });
    } else if (generalcat == 'Carpool') {
      setState(() {
        selectCat = "Carpool";
        subcat = carpoolsubcat;
        selectSubCat = null;
      });
    } else if (generalcat == 'Clubs') {
      setState(() {
        selectCat = "Clubs";
        subcat = clubsSubcat;
        selectSubCat = null;
      });
    } else if (generalcat == 'Creative') {
      setState(() {
        selectCat = "Creative";
        subcat = creativeSubcat;
        selectSubCat = null;
      });
    } else if (generalcat == 'Gaming') {
      setState(() {
        selectCat = "Gaming";
        subcat = gamingSubcat;
        selectSubCat = null;
      });
    } else if (generalcat == 'Volunteer') {
      setState(() {
        selectCat = "Volunteer";
        subcat = volunteerSubcat;
        selectSubCat = null;
      });
    } else {
      setState(() {
        subcat = [];
        selectSubCat = null;
      });
    }
  }

  Widget _buildDeleteDialogue(
      BuildContext context, String eventName, int eventID) {
    return AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.black,
          child: Text("Permenently Delete " + eventName + " ($eventID)?",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: globals.friendzoneYellow, fontSize: 25)),
        ),
        content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Future<void> delete = deleteEvent(eventID);
                  },
                  textColor: const Color.fromARGB(255, 0, 0, 255),
                  child: const Text("Confirm")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: const Color.fromARGB(255, 254, 0, 0),
                  child: const Text("Cancel")),
            ]));
  }
}
