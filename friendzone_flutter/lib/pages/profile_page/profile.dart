import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';

import 'package:friendzone_flutter/db_comm/make_post_request.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/globals.dart' as globals;
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/pages/event_page/event_full_view.dart';
import 'package:friendzone_flutter/pages/modules.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Event>>? _myEvents;
  Future<List<Event>>? _joinedEvents;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    
    _myEvents = getMyEvents(globals.activeUser!.email);
    //_myEvents = getAllEvents();
    //_joinedEvents = getJoinedEvents(globals.activeUser!.email);
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
          children: [
            Text(
              globals.activeUser!.name,
              style: const TextStyle(
                  fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  globals.activeUser!.email,
                  style: const TextStyle(
                  fontSize: 20),
                ),
                const SizedBox(
                  width: 60,
                ),
                Text(
                  globals.activeUser!.contact,
                  style: const TextStyle(
                  fontSize: 20),
                )
              ],
            ),
            Text(
              globals.activeUser!.introduction,
              textAlign: TextAlign.justify,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        child: _myEvents == null
                            ? Container()
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
                                          leading: const Icon(FontAwesomeIcons.atom),
                                          title: Text(snapshot.data![index].title),
                                          subtitle: Text(
                                              "Where: ${snapshot.data![index].location}\n"
                                              "When: ${snapshot.data![index].time}\n"
                                              "# of Slots: ${snapshot.data![index].slots}"),
                                         /* onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailEventViewPage(
                                                            data: snapshot.data![index])));
                                          }, */
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
                  Column(
                    children: [
                    ],
                  )
                ],
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _myEvents = getMyEvents(globals.activeUser!.email);
            });
          },
          backgroundColor: globals.friendzoneYellow,
          child: const Icon(Icons.restart_alt)),
    );
  }
}
