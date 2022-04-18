import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/models/notification.dart' as noti;
import 'package:friendzone_flutter/globals.dart' as globals;

class ViewNotfication extends StatefulWidget {
  const ViewNotfication({Key? key}) : super(key: key);

  @override
  _ViewNotfication createState() => _ViewNotfication();
}

class _ViewNotfication extends State<ViewNotfication> {
  Future<List<noti.Notification>>? _notfication;

  @override
  void initState() {
    super.initState();

    _notfication = getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      backgroundColor: const Color(0xFFDCDCDC), // Background color
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FontAwesomeIcons.bell),
                SizedBox(
                  width: 10,
                ),
                Text("Notifications"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: _notfication == null
                  ? Container()
                  : FutureBuilder<List<noti.Notification>>(
                      future: _notfication,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Text("No notifications yet");
                          } else {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  IconData _envelope =
                                      FontAwesomeIcons.envelopeCircleCheck;
                                  if (snapshot.data![index].seen) {
                                    _envelope =
                                        FontAwesomeIcons.envelopeCircleCheck;
                                  }
                                  return ListTile(
                                    leading: Icon(_envelope),
                                    title:
                                        Text(snapshot.data![index].eventTitle),
                                    subtitle:
                                        Text("${snapshot.data![index].text}\n"
                                            "${snapshot.data![index].time}"),
                                  );
                                },
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error!}");
                        }
                        return const CircularProgressIndicator();
                      }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _notfication = getNotifications();
          });
        },
        backgroundColor: globals.friendzoneYellow,
        child: const Icon(
          Icons.restart_alt,
          color: Colors.black,
        ),
      ),
    );
  }
}
