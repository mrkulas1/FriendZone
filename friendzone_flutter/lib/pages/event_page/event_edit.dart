import 'dart:ui';

import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';

class EventEditPage extends StatefulWidget {
  final Event event;

  void click() {}
  const EventEditPage({Key? key, required this.event}) : super(key: key);

  @override
  EventEditPageState createState() {
    return EventEditPageState();
  }
}

class EventEditPageState extends State<EventEditPage> {
  final TextEditingController _eventNameEdit = TextEditingController();
  final TextEditingController _locationEdit = TextEditingController();
  final TextEditingController _numSlotsEdit = TextEditingController();
  final TextEditingController _datetimeEdit = TextEditingController();
  final TextEditingController _categoryEdit = TextEditingController();
  final TextEditingController _descriptionEdit = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _eventNameEdit.text = widget.event.title;
    _locationEdit.text = widget.event.location;
    _categoryEdit.text = widget.event.category.toString();
    _numSlotsEdit.text = widget.event.slots.toString();
    _descriptionEdit.text = widget.event.description ?? "";
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
                    const Text(
                      "Edit your Event",
                      style: TextStyle(
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please add a name';
                          } else if (value.length > 100) {
                            return 'Too long';
                          }
                          return null;
                        },
                        controller: _eventNameEdit,
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
                          }
                          return null;
                        },
                        controller: _locationEdit,
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
                            }
                            return null;
                          } on Exception catch (_) {
                            return 'Please enter a whole number';
                          }
                        },
                        controller: _numSlotsEdit,
                        decoration: const InputDecoration(
                            labelText: "Number of Slots",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 70,
                          width: 64,
                          padding: const EdgeInsets.only(bottom: 35),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  globals.friendzoneYellow),
                            ),
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: const Text("Date"),
                          ),
                        ),
                        Container(
                          height: 70,
                          width: 90,
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                              "${dateTime.month}/${dateTime.day}/${dateTime.year}"),
                        ),
                        Container(
                          height: 70,
                          width: 64,
                          padding: const EdgeInsets.only(bottom: 35),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  globals.friendzoneYellow),
                            ),
                            onPressed: () {
                              _selectTime(context);
                            },
                            child: const Text("Time"),
                          ),
                        ),
                        Container(
                          height: 70,
                          width: 60,
                          padding: const EdgeInsets.only(left: 8, top: 10),
                          child: Text(
                              "${selectedTime.hour}:${selectedTime.minute}"),
                        ),
                      ],
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        // may have issue with toString
                        validator: (value) {
                          return null;
                        },
                        controller: _categoryEdit,
                        decoration: const InputDecoration(
                            labelText: "Category",
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
                          return null;
                        },
                        controller: _descriptionEdit,
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Updating Event ...')),
                          );

                          Future<Event> newEvent = updateEvent(
                              widget.event.id,
                              _eventNameEdit.text,
                              _descriptionEdit.text,
                              _locationEdit.text,
                              _datetimeEdit.text,
                              int.parse(_numSlotsEdit.text),
                              0);

                          newEvent.then((value) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        DetailEventViewPage(data: value)));
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())));
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
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Update',
                            style: TextStyle(
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

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? dateTimeFinal = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.utc(DateTime.now().year + 5),
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (dateTimeFinal != null && dateTimeFinal != dateTime) {
      setState(() {
        dateTime = dateTimeFinal;
      });
    }
  }
}
