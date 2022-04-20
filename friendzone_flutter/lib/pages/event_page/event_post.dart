import 'package:flutter/foundation.dart';
import 'package:friendzone_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:flutter/material.dart';

/// This class is used to display fields to allow users to post events
class EventPostPage extends StatefulWidget {
  static const String routeName = '/post';

  final Event? event;
  final bool editable;

  void click() {}
  const EventPostPage({Key? key, required this.editable, this.event})
      : super(key: key);

  @override
  EventPostPageState createState() {
    return EventPostPageState();
  }
}

class EventPostPageState extends State<EventPostPage> {
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _numSlots = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _description = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();

  DateTime _dateTime = DateTime.now();
  ProfanityFilter filter = ProfanityFilter();
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
  final List<String> creativeSubcat = ['Art', 'Music', 'Other'];
  final List<String> gamingSubcat = [
    'Video Games',
    'Board Games',
    'Card Games',
    'Other'
  ];
  final List<String> volunteerSubcat = ['Michigan Tech', 'Community', 'Other'];
  List<String> subcat = [];
  String? selectCat;
  String? selectSubCat;

  @override
  void initState() {
    super.initState();
    // set up time of day
    if (_selectedTime.hour == 23) {
      _selectedTime = const TimeOfDay(hour: 0, minute: 0);
      _dateTime = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    } else {
      _selectedTime = TimeOfDay(hour: _selectedTime.hour + 1, minute: 0);
    }
    if (!widget.editable || widget.event == null) {
      return;
    }

    _eventName.text = widget.event!.title;
    _location.text = widget.event!.location;
    _category.text = widget.event!.category.toString();
    _numSlots.text = widget.event!.slots.toString();
    _description.text = widget.event!.description ?? "";

    //selectCat = widget.event!.category;
    onChangedCallback(widget.event!.category);
    selectSubCat = widget.event!.subCat == "" ? null : widget.event!.subCat;

    try {
      _dateTime = DateTime.parse(widget.event!.time);
      _selectedTime =
          TimeOfDay.fromDateTime(DateTime.parse(widget.event!.time));
    } catch (e) {
      TimeOfDay _selectedTime = TimeOfDay.now();
      DateTime _dateTime = DateTime.now();
    }
  }

  final _postFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: SingleChildScrollView(
        child: Form(
          key: _postFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 1000,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Friend Zone",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.editable ? "Update Event" : "Create an Event",
                      style: const TextStyle(
                        color: Color.fromARGB(66, 5, 5, 5),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        // check that text is permitted
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please add a name';
                          } else if (value.length > 100) {
                            return 'Too long';
                          } else if (filter.hasProfanity(value)) {
                            return 'Keep content FriendZone friendly!';
                          }
                          return null;
                        },
                        controller: _eventName,
                        decoration: const InputDecoration(
                            labelText: "Event Name",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        validator: (value) {
                          if (value != null && value.length > 100) {
                            return 'Too long';
                          } else if (filter.hasProfanity(value!)) {
                            return 'Keep content FriendZone friendly!';
                          }
                          return null;
                        },
                        controller: _location,
                        decoration: const InputDecoration(
                            labelText: "Location",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        validator: (value) {
                          try {
                            if (value != null) {
                              int a = int.parse(value);
                              if (a < 1) {
                                throw new Exception();
                              }
                            } else if (filter.hasProfanity(value!)) {
                              return 'Keep content FriendZone friendly!';
                            }
                            return null;
                          } on Exception catch (_) {
                            return 'Please enter a positive whole number';
                          }
                        },
                        controller: _numSlots,
                        decoration: const InputDecoration(
                            labelText: "Number of Slots",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      padding: const EdgeInsets.only(bottom: 35),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              globals.friendzoneYellow),
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text(
                            "${_dateTime.month}/${_dateTime.day.toString().padLeft(2, '0')}/${_dateTime.year}"),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      padding: const EdgeInsets.only(bottom: 35),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                globals.friendzoneYellow),
                          ),
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Text(_selectedTime.format(context))),
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: DropdownButton<String>(
                        hint: Text('Category'),
                        value: selectCat,
                        items: generalcat.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: onChangedCallback,
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 90,
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: DropdownButton<String>(
                        hint: Text('Subcategory'),
                        value: selectSubCat,
                        items: subcat.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (subcat) {
                          setState(() {
                            selectSubCat = subcat;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        validator: (value) {
                          if (filter.hasProfanity(value!)) {
                            return 'Keep content FriendZone friendly!';
                          }
                          return null;
                        },
                        controller: _description,
                        decoration: const InputDecoration(
                            labelText: "Description of Event",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_postFormKey.currentState!.validate()) {
                          String formattedDateTime =
                              "${_dateTime.year.toString().padLeft(4, '0')}-"
                              "${_dateTime.month.toString().padLeft(2, '0')}-"
                              "${_dateTime.day.toString().padLeft(2, '0')} "
                              "${_selectedTime.hour.toString().padLeft(2, '0')}:"
                              "${_selectedTime.minute.toString().padLeft(2, '0')}:00";
                          globals.makeSnackbar(context, "Creating Event...");
                          Future<Event> event = widget.editable
                              ? updateEvent(
                                  widget.event!.id,
                                  _eventName.text,
                                  _description.text,
                                  _location.text,
                                  formattedDateTime,
                                  int.parse(_numSlots.text),
                                  selectCat ?? "",
                                  selectSubCat ?? "")
                              : createEvent(
                                  globals.activeUser?.email ?? "",
                                  _eventName.text,
                                  _description.text,
                                  _location.text,
                                  formattedDateTime,
                                  int.parse(_numSlots.text),
                                  selectCat ?? "",
                                  selectSubCat ?? "");

                          event.then((value) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailEventViewPage(data: value)));
                          }).catchError((error) {
                            globals.unifiedErrorCatch(context, error);
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            globals.friendzoneYellow),
                      ),
                      child: Container(
                        width: 220,
                        height: 60,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            widget.editable ? 'Update' : 'Create Event',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// this checks that the time of day is permitted and sets it if permitted
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      if (_dateTime.isBefore(DateTime.now())) {
        if (timeOfDay.hour > TimeOfDay.now().hour ||
            (timeOfDay.hour == TimeOfDay.now().hour &&
                timeOfDay.minute > TimeOfDay.now().minute)) {
          setState(() {
            _selectedTime = timeOfDay;
          });
        } else {
          globals.makeSnackbar(context, "Cannot set event time to the past");
        }
      } else {
        setState(() {
          _selectedTime = timeOfDay;
        });
      }
    }
  }

// this checks that the date and time are permitted and sets it if permitted
  _selectDate(BuildContext context) async {
    if (_dateTime.isBefore(DateTime.now())) {
      _dateTime = DateTime.now();
    }
    final DateTime? dateTimeFinal = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.utc(DateTime.now().year + 5),
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (dateTimeFinal != null && dateTimeFinal != _dateTime) {
      setState(() {
        _dateTime = dateTimeFinal;
      });
    }
  }

// this is used to set the categories
  void onChangedCallback(generalcat) {
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
        selectCat = "Other";
        subcat = [];
        selectSubCat = null;
      });
    }
  }
}
