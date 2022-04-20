import 'dart:ui';

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

/// This class builds the user interface for the user profile page and accounts
/// for whether or not the current user matches that of the profile page.
/// Additionally, admin permissions will allow the current user to delete events
/// regardless of the profile if they are an administrator.

class ProfilePage extends StatefulWidget {
  bool owner = false;
  String? email;
  Future<ForeignUser>? user;

  ProfilePage({Key? key, this.email}) : super(key: key) {
    if (email == null || email == globals.activeUser!.email) {
      user = Future<ForeignUser>.value(globals.activeUser);
      email = globals.activeUser!.email;
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

    if (!widget.owner) {
      widget.user = getForeignUser(widget.email.toString());
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
                                                builder: (BuildContext
                                                        context) =>
                                                    const ProfileEditPage()));
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
                                    //Displays events that the user depicted in
                                    //the profile has created

                                    if (snapshot.hasData) {
                                      return Expanded(
                                          child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, int index) {
                                          return ListTile(
                                              leading: Icon(customIcons(snapshot
                                                  .data![index].category)),
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
                                              trailing: _buildX(
                                                  snapshot.data!
                                                      .elementAt(index),
                                                  snapshot.data![index].id,
                                                  snapshot.data![index].title,
                                                  globals.activeUser!
                                                      .isAdmin()));
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

                        //Displays all events user is currently joined in

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
                                            leading: Icon(customIcons(snapshot
                                                .data![index].category)),
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

  /// Builds dialogue for deleting an event, performs actions
  /// if user does so choose

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
                    delete.then((value) {
                      setState(() {
                        Navigator.of(context).pop();
                        _myEvents = getMyEvents(widget.email.toString());
                        _joinedEvents =
                            getJoinedEvents(widget.email.toString());
                      });
                    });
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

  /// Builds the option to delete an event in the form of an "X"
  /// as a trailer if the current user is an administrater or the current
  /// user matches the user described in the profile

  Widget _buildX(Event e, int id, String title, bool isAdmin) {
    if (!isAdmin) {
      return const Spacer(flex: 1);
    } else if (globals.activeUser!.email != e.userEmail) {
      return const Spacer(flex: 1);
    }
    return IconButton(
      icon: const Icon(
        FontAwesomeIcons.xmark,
        color: Colors.black,
      ),

      //color: globals.friendzoneYellow,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                _buildDeleteDialogue(context, title, id));
      },
    );
  }
}
