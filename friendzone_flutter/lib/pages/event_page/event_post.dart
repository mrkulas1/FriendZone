import 'package:friendzone_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';

class EventPostPage extends StatefulWidget {
  //final Event event;

  void click() {}
  const EventPostPage({Key? key}) : super(key: key);
//  const EventPostPage({Key? key, required this.event}) : super(key: key)

  @override
  EventPostPageState createState() {
    return EventPostPageState();
  }
}

class EventPostPageState extends State<EventPostPage> {
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _numSlots = TextEditingController();
  final TextEditingController _datetime = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final _postFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Create an Event",
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
                            }
                            return null;
                          } on Exception catch (_) {
                            return 'Please enter a whole number';
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
                      child: TextFormField(
                        validator: (value) {
                          return null;
                        },
                        controller: _datetime,
                        decoration: const InputDecoration(
                            labelText: "Date/Time",
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
                        controller: _category,
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
                      onPressed: () => {
                        if (_postFormKey.currentState!.validate())
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Creating Event ...')),
                            )
                            // createEvent(userEmail, title, description, location, time, slots, category)
                            // Use for Create Event
                          }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 255, 204, 0)),
                      ),
                      child: Container(
                        width: 220,
                        height: 60,
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Create Event',
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
}
