/// TODO: Figure out a better UI layout for this page
import 'dart:html';
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

  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          appBar: const Header(),
          body: SizedBox(
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.data.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            child: globals.activeUser!.email ==
                                    widget.data.userEmail
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              EventPostPage(
                                                  editable: true,
                                                  event: widget.data),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              globals.friendzoneYellow),
                                    ),
                                    child: const Text("Edit"),
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var messageController =
                                        TextEditingController();
                                    return AlertDialog(
                                      title: const Text(
                                          'Please confirm you would like to join this event'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              TextFormField(
                                                controller: messageController,
                                                decoration: const InputDecoration(
                                                    labelText:
                                                        'Is there anything you would like to let the event creator know?'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      globals.friendzoneYellow),
                                            ),
                                            child: const Text("Join"),
                                            onPressed: () {
                                              var comment =
                                                  messageController.text;
                                              Future<void> joined = joinEvent(
                                                  globals.activeUser!.email,
                                                  widget.data.id,
                                                  comment);

                                              joined.then((value) {
                                                setState(() {
                                                  _signUpUser =
                                                      getSignedUpUsers(
                                                          widget.data.id);
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        "Joined successfully"),
                                                  ),
                                                );
                                              }).catchError((error) {
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      error.toString(),
                                                    ),
                                                  ),
                                                );
                                              });
                                              Navigator.pop(context);
                                            })
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  globals.friendzoneYellow),
                            ),
                            child: const Text("Join"),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            "Posted on ${widget.data.dateCreated ?? ""}\n"
                            "Posted by ${widget.data.userEmail}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 25),
                          ElevatedButton(
                            onPressed: () {
                              Future<void> left = leaveEvent(
                                  globals.activeUser!.email, widget.data.id);

                              left.then((value) {
                                setState(() {
                                  _signUpUser =
                                      getSignedUpUsers(widget.data.id);
                                });
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Left successfully"),
                                  ),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.toString(),
                                    ),
                                  ),
                                );
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  globals.friendzoneYellow),
                            ),
                            child: const Text("Leave"),
                          ),
                        ],
                      ),
                      // Buttons and post information
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TitledContainer(
                            title: "Description",
                            textAlign: TextAlignTitledContainer.Center,
                            fontSize: 16.0,
                            backgroundColor: Colors.white,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Scrollbar(
                                isAlwaysShown: true,
                                controller: _firstController,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.data.description ?? "",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Location",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.data.location),
                              ),

                              // Time
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Time",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.data.time),
                              ),

                              // Slots
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Slots",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Available: ${widget.data.slots}\n"
                                    "Total: ${widget.data.slots}"),
                              ),
                            ],
                          ),
                          TitledContainer(
                            titleColor: Colors.black,
                            title: 'Signed Up',
                            textAlign: TextAlignTitledContainer.Center,
                            fontSize: 16.0,
                            backgroundColor: Colors.white,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4,
                              height: MediaQuery.of(context).size.height / 2,
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
                                  : FutureBuilder<List<ForeignUser>>(
                                      future: _signUpUser,
                                      builder: (context, snapshot) {
                                        // TODO Scrollable
                                        if (snapshot.hasData) {
                                          return Expanded(
                                            child: Scrollbar(
                                              isAlwaysShown: true,
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(), // Changing physic doesn't do the trick
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder:
                                                    (context, int index) {
                                                  return ListTile(
                                                    title: Text(snapshot
                                                        .data![index].name),
                                                    subtitle: Text(
                                                        "${snapshot.data![index].email}\n"),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error!}");
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
