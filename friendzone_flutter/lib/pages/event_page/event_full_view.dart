import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_titled_container/flutter_titled_container.dart';

import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';
import 'package:friendzone_flutter/pages/profile_page/profile.dart';

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
      appBar: const Header(),
      backgroundColor: const Color(0xFFDCDCDC),
      body: SingleChildScrollView(
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
                        child:
                            globals.activeUser!.email == widget.data.userEmail
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
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.black),
                                    ),
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
                      globals.activeUser!.email != widget.data.userEmail
                        ? ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var messageController = TextEditingController();
                                    return AlertDialog(
                                      title: const Text(
                                          'Please confirm you would like to join this event'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 500,
                                                child: TextFormField(
                                                  maxLines: 7,
                                                  minLines: 1,
                                                  controller: messageController,
                                                  decoration: const InputDecoration(
                                                      labelText:
                                                          'Is there anything you would like to let the event creator know?'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<Color>(
                                                      globals.friendzoneYellow),
                                            ),
                                            child: const Text(
                                              "Join",
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            onPressed: () {
                                              var comment = messageController.text;
                                              Future<void> joined = joinEvent(
                                                  globals.activeUser!.email,
                                                  widget.data.id,
                                                  comment);

                                              joined.then((value) {
                                                setState(() {
                                                  _signUpUser = getSignedUpUsers(
                                                      widget.data.id);
                                                });
                                                globals.makeSnackbar(
                                                    context, "Joined successfully");
                                              }).catchError((error) {
                                                globals.unifiedErrorCatch(
                                                    context, error);
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
                            child: const Text(
                              "Join",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : Container(),
                      const SizedBox(width: 25),
                      Column(
                        children: [
                          Text(
                            "Posted on ${widget.data.dateCreated ?? ""}",
                            style: const TextStyle(fontSize: 14),
                          ),
                          TextButton(
                            child: Text("Posted by ${widget.data.userEmail}"),
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 14),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePage(
                                          email: widget.data.userEmail)));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      ElevatedButton(
                        onPressed: () {
                          Future<void> left = leaveEvent(
                              globals.activeUser!.email, widget.data.id);

                          left.then((value) {
                            setState(() {
                              _signUpUser = getSignedUpUsers(widget.data.id);
                            });
                            globals.makeSnackbar(context, "Left successfully");
                          }).catchError((error) {
                            globals.unifiedErrorCatch(context, error);
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              globals.friendzoneYellow),
                        ),
                        child: const Text(
                          "Leave",
                          style: TextStyle(color: Colors.black),
                        ),
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
                        backgroundColor: const Color(0xFFDCDCDC),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height / 2,
                          ),
                          width: MediaQuery.of(context).size.width / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                  fontSize: 24, fontWeight: FontWeight.bold),
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
                                  fontSize: 24, fontWeight: FontWeight.bold),
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
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                              child: _signUpUser == null
                                  ? Container()
                                  : FutureBuilder<List<ForeignUser>>(
                                      future: _signUpUser,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              "Available: ${widget.data.slots - snapshot.data!.length}\n"
                                              "Total: ${snapshot.data!.length}");
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error!}");
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                    )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Category",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${widget.data.category}, ${widget.data.subCat}"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: (() {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    var reportControlloer =
                                        TextEditingController();
                                    return AlertDialog(
                                      title: const Text(
                                          'Please confirm you would like to report this event'),
                                      content: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 500,
                                                child: TextFormField(
                                                  maxLines: 7,
                                                  minLines: 1,
                                                  autofocus: false,
                                                  controller: reportControlloer,
                                                  decoration: const InputDecoration(
                                                      labelText:
                                                          'Reason for report?'),
                                                ),
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
                                            child: const Text(
                                              "Report",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              var comment =
                                                  reportControlloer.text;
                                              Future<void> joined = reportEvent(
                                                  globals.activeUser!.email,
                                                  widget.data.id,
                                                  comment);

                                              joined.then((value) {
                                                setState(() {
                                                  _signUpUser =
                                                      getSignedUpUsers(
                                                          widget.data.id);
                                                });
                                                globals.makeSnackbar(context,
                                                    "Report successful");
                                              }).catchError((error) {
                                                globals.unifiedErrorCatch(
                                                    context, error);
                                              });
                                              Navigator.pop(context);
                                            })
                                      ],
                                    );
                                  });
                            }),
                            child: const Text(
                              "Report",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        globals.friendzoneYellow)),
                          )
                        ],
                      ),
                      TitledContainer(
                        titleColor: Colors.black,
                        title: 'Signed Up',
                        textAlign: TextAlignTitledContainer.Center,
                        fontSize: 16.0,
                        backgroundColor: const Color(0xFFDCDCDC),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          // constraints: BoxConstraints(
                          //   minHeight: MediaQuery.of(context).size.height / 2,
                          // ),
                          width: MediaQuery.of(context).size.width / 4,
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
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, int index) {
                                          return ListTile(
                                            title: Text(
                                                snapshot.data![index].name),
                                            subtitle: Text(
                                                "${snapshot.data![index].email}\n"),
                                          );
                                        },
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
  }
}
