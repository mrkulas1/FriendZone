import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'pages/event_page/event_post.dart';
import 'main.dart';

class Header extends AppBar {
  Header({Key? key})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Color(0xFFFFCC00), //change your color here
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text(
            "Friend Zone",
            style: TextStyle(
              color: Color(0xFFFFCC00),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  // DIRECT TO ACCOUNT INFORMATION PAGE
                },
                icon: const Icon(
                  FontAwesomeIcons.user,
                  color: Color(0xFFFFCC00),
                ),
              ),
            ),
          ],
        );
}

class CoustomDrawer extends StatelessWidget {
  const CoustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            // We can add a logo/picture here for decoration
            decoration: BoxDecoration(
              color: Colors.amberAccent,
            ),
            child: Text(''),
          ),
          ListTile(
            textColor: const Color(0xFFFFCC00),
            title: const Text('Home'),
            onTap: () {
              // TAKE ME HOMEEEEEEEEEEEEEEEEEEEEE
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyApp()));
            },
          ),
          ListTile(
            textColor: const Color(0xFFFFCC00),
            title: const Text('Post Event'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const EventPostPage()),
                ),
              );
            },
          ),
          ListTile(
            textColor: const Color(0xFFFFCC00),
            title: const Text('Do something'),
            onTap: () {
              // Do something
            },
          ),
        ],
      ),
    );
  }
}
