import 'package:flutter/material.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/pages/event_page/event_edit.dart';
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import 'pages/login_page/login.dart';
import 'pages/login_page/signup.dart';
import 'pages/event_page/event_viewing.dart';

void main() {
  runApp(const MaterialApp(
    title: 'FriendZone',
    home: MyApp(),
  ));
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
                  MaterialPageRoute(builder: (context) => const EventPostPage()));
            },
          ),
          ElevatedButton(
            child: const Text("Event View"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventViewApp()));
            },
          ),
          ElevatedButton(
            child: const Text("Sign up"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()));
            },
            ),
            ElevatedButton(
            child: const Text("Edit Post"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventEditPage(event: Event(id: 0 ,category: 0, title: 'Test Title', userEmail: 'Test Email' , time: 'Test time',location: 'Test location', slots: 5, ),)));
            },
            ),
        ])
      )
    );
  }
}
