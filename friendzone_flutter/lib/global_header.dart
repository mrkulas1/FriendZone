import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/pages/event_page/event_viewing.dart';
import 'package:friendzone_flutter/pages/login_page/login.dart';

import 'globals.dart' as globals;
import 'pages/event_page/event_post.dart';

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

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const DrawerHeader(
            // We can add a logo/picture here for decoration
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage("images/Drawer_img.png"),
                  fit: BoxFit.contain),
            ),
            child: Text(''),
          ),
          ListTile(
            tileColor: const Color(0xFFFFCC00),
            textColor: Colors.black,
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              // TAKE ME HOMEEEEEEEEEEEEEEEEEEEEE
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EventViewAllPage()));
            },
          ),
          ListTile(
            tileColor: const Color(0xFFFFCC00),
            textColor: Colors.black,
            title: const Text(
              'Post Event',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const EventPostPage(editable: false)),
                ),
              );
            },
          ),
          ListTile(
            tileColor: const Color(0xFFFFCC00),
            textColor: Colors.black,
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              globals.activeUser = null;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: ((context) => const LoginPage())));
            },
          ),
        ],
      ),
    );
  }
}
