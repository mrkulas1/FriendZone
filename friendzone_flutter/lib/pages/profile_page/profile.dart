import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/make_post_request.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';
import 'package:friendzone_flutter/pages/modules.dart';
import 'package:friendzone_flutter/pages/profile_page/profile_edit.dart';

class ProfilePage extends StatefulWidget {
  bool owner = false;
  String? email;
<<<<<<< HEAD
  ForeignUser? user;
  ProfilePage({Key? key, this.email}) : super(key: key) {
    if (email == null || email == globals.activeUser!.email) {
      //user = globals.activeUser as Future<ForeignUser>?;
=======
  Future<ForeignUser>? user;
  
  ProfilePage({Key? key, this.email}) : super(key: key) {
    if (email == null || email == globals.activeUser!.email) {
      user = Future<ForeignUser>.value(globals.activeUser);
      email = globals.activeUser!.email;
>>>>>>> a59c23c289c5a73585fc8862cd95a321baac1ac6
      owner = true;
    }
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Event>>? _myEvents;
  Future<List<Event>>? _joinedEvents;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    if (widget.owner) {
      widget.user = globals.activeUser;
    } else {
      getForeignUser(widget.email.toString()).then((value) {
        widget.user = value;
      });
=======

    if (!widget.owner) {
      widget.user = getForeignUser(widget.email.toString());
>>>>>>> a59c23c289c5a73585fc8862cd95a321baac1ac6
    }

    _myEvents = getMyEvents(widget.email.toString());
    _joinedEvents = getJoinedEvents(widget.email.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFDCDCDC), // Background color
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              child: widget.user == null
                  ? Container()
                  : FutureBuilder<ForeignUser>(
                      future: widget.user,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(children: [
                            Text(
                              snapshot.data!.name,
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data!.email,
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  width: 60,
                                ),
                                Text(
                                  snapshot.data!.contact,
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                            Text(
                              snapshot.data!.introduction,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: widget.owner
                                  ? ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const ProfileEditPage()));
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                globals.friendzoneYellow),
                                      ),
                                      child: const Text("Edit"))
                                  : Container(),
                            ),
                          ]);
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error!}");
                        }
                        return const CircularProgressIndicator();
                      },
                    ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Created Events"),
                        Container(
                          child: _myEvents == null
                              ? const Text("No Created Events")
                              : FutureBuilder<List<Event>>(
                                  future: _myEvents,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Expanded(
                                          child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, int index) {
                                          return ListTile(
                                            leading: const Icon(
                                                FontAwesomeIcons.atom),
                                            title: Text(
                                                snapshot.data![index].title),
                                            subtitle: Text(
                                                "Where: ${snapshot.data![index].location}\n"
                                                "When: ${snapshot.data![index].time}\n"
                                                "# of Slots: ${snapshot.data![index].slots}"),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailEventViewPage(
                                                              data: snapshot
                                                                      .data![
                                                                  index])));
                                            },
                                            trailing: IconButton(
                                              icon: const Icon(
                                                  FontAwesomeIcons.x),
                                              //color: globals.friendzoneYellow,
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          _buildDeleteDialogue(
                                                              context,
                                                              snapshot
                                                                  .data![index]
                                                                  .title),
                                                );
                                              },
                                            ),
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
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Joined Events"),
                        Container(
                          child: _joinedEvents == null
                              ? const Text("No Joined Events")
                              : FutureBuilder<List<Event>>(
                                  future: _joinedEvents,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Expanded(
                                          child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, int index) {
                                          return ListTile(
                                            leading: const Icon(
                                                FontAwesomeIcons.atom),
                                            title: Text(
                                                snapshot.data![index].title),
                                            subtitle: Text(
                                                "Where: ${snapshot.data![index].location}\n"
                                                "When: ${snapshot.data![index].time}\n"
                                                "# of Slots: ${snapshot.data![index].slots}"),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailEventViewPage(
                                                              data: snapshot
                                                                      .data![
                                                                  index])));
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
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _myEvents = getMyEvents(widget.email.toString());
              _joinedEvents = getJoinedEvents(widget.email.toString());
            });
          },
          backgroundColor: globals.friendzoneYellow,
          child: const Icon(Icons.restart_alt)),
    );
  }

  Widget _buildDeleteDialogue(BuildContext context, String eventName) {
    return AlertDialog(
        title: Text("Permenently Delete " + eventName + "?"),
        content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
