import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/pages/event_page/event_viewing.dart';
import 'package:friendzone_flutter/pages/login_page/login.dart';
import 'package:friendzone_flutter/pages/profile_page/profile.dart';
import 'package:friendzone_flutter/pages/moderation_page/report_view.dart';
import 'package:friendzone_flutter/pages/notfication_page/notification_page.dart';

import 'globals.dart' as globals;
import 'pages/event_page/event_post.dart';

/// This class handles the header bar that appears at the top of each
/// page in the app
class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ViewNotfication()));
            },
            icon: const Icon(
              FontAwesomeIcons.bell,
              color: Color(0xFFFFCC00),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            onPressed: () {
              // DIRECT TO ACCOUNT INFORMATION PAGE
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
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
              'Profile',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => ProfilePage())));
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
          globals.activeUser!.isAdmin()
              ? ListTile(
                  tileColor: const Color(0xFFFFCC00),
                  textColor: Colors.black,
                  title: const Text(
                    'View Reports',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const ReportsPage())));
                  },
                )
              : const SizedBox(height: 0, width: 0),
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
