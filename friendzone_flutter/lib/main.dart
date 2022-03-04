import 'package:flutter/material.dart';
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import 'pages/login_page/login.dart';
import 'pages/login_page/signup.dart';
import 'pages/event_page/event_viewing.dart';
import 'global_header.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'FriendZone',
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Home'),
        ),
        body: Center(
            child: Column(children: [
          ElevatedButton(
            child: const Text('Log In'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          ElevatedButton(
            child: const Text("Post"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventPostPage()));
            },
          ),
          ElevatedButton(
            child: const Text("Event View"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventViewApp()));
            },
          ),
          ElevatedButton(
            child: const Text("Sign up"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()));
            },
          ),
          ElevatedButton(
            child: const Text("Header"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Header()));
            },
          ),
        ])));
  }
}
