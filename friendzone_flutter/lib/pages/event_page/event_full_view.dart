/// TODO: Figure out a better UI layout for this page
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter_titled_container/flutter_titled_container.dart';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import '../../models/foreign_user.dart';
import 'event_viewing.dart';

class DetailEventViewPage extends StatefulWidget {
  final Event data;
  const DetailEventViewPage({Key? key, required this.data}) : super(key: key);
  @override
  _DetailEventViewPageState createState() => _DetailEventViewPageState();
}

class _DetailEventViewPageState extends State<DetailEventViewPage> {
  Future<List<ForeignUser>>? _signUpUser;

  @override
  void initState() {
    super.initState();

    _signUpUser = getSignedUpUsers(widget.data.id);
  }

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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {/*TODO: Join Logic*/
                                showDialog (
                                  context: context,
                                  builder: (context) {
                                    var messageController = TextEditingController();
                                    return AlertDialog(
                                      title: const Text('Please confirm you would like to join this event'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            children: <Widget> [
                                              TextFormField(
                                                controller: messageController,
                                                decoration: InputDecoration(
                                                  labelText: 'Is there anything you would like to let the event creator know?'
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          child: const Text("Join"),
                                          onPressed: () {
                                            var comment = messageController.text;
                                            joinEvent(widget.data.userEmail, widget.data.id, comment);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                 builder: (BuildContext context) =>
                                                   const EventViewAllPage()));
                                          }
                                          )
                                      ],
                                    );
                                  }
                                );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          globals.friendzoneYellow),
                                ),
                                child: const Text("Join")),
                            ElevatedButton(
                                onPressed: () {/*TODO: Leave Logic*/},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          globals.friendzoneYellow),
                                ),
                                child: const Text("Leave")),
                          ],
                        ),
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
                                            EventPostPage(
                                                editable: true,
                                                event: widget.data)));
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
                    TitledContainer(
                      titleColor: Colors.black,
                      title: 'Signed Up',
                      textAlign: TextAlignTitledContainer.Center,
                      fontSize: 16.0,
                      backgroundColor: Colors.white,
                      child: Container(
                        
                        width:
                            500.0, // Change here to change the width of the box
                        height: 200.0, // Change to change the height of the box
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        child: _signUpUser == null
                            ? Container()
                            : FutureBuilder(
                                future: _signUpUser,
                                builder: (context, snapshot) {
                                  // TODO implement the stuff here
                                  return const Center(
                                    child: Text(
                                      'PUT YOUR STUFF HERE',
                                      style: TextStyle(fontSize: 29.0),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
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
