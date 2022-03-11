/// TODO: Figure out a better UI layout for this page
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/pages/event_page/event_edit.dart';
import 'event_viewing.dart';

class DetailEventViewPage extends StatefulWidget {
  final Event data;
  const DetailEventViewPage({Key? key, required this.data}) : super(key: key);
  @override
  _DetailEventViewPageState createState() => _DetailEventViewPageState();
}

class _DetailEventViewPageState extends State<DetailEventViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Container(
                //width: 325,
                padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
                decoration: const BoxDecoration(
                  //color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.data.title,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),

                    // Buttons and post information
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {/*TODO: Join Logic*/},
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  globals.friendzoneYellow),
                            ),
                            child: const Text("Join")),
                        Text(
                            "Posted on ${widget.data.dateCreated ?? ""}\n"
                            "Posted by ${widget.data.userEmail}",
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: globals.activeUser!.email == widget.data.userEmail
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EventEditPage(event: widget.data)));
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        globals.friendzoneYellow),
                              ),
                              child: const Text("Edit"))
                          : Container(),
                    ),

                    // Description
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.data.description ?? "")),

                    // Location
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Location",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.data.location)),

                    // Time
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Time",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.data.time)),

                    // Slots
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Slots",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Available: ${widget.data.slots}\n" // TODO: Logic for # of users signed up
                            "Total: ${widget.data.slots}")),

                    // Signed Up Users
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Signed Up Users",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    // TODO: Logic to figure out who is signed up for an event
                    // TODO: Add Category once the enum is set up
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
