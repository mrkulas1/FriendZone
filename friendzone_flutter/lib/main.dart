import 'package:flutter/material.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import 'pages/login_page/login.dart';
import 'pages/login_page/signup.dart';
import 'pages/event_page/event_viewing.dart';

void main() {
  runApp(const MaterialApp(
    title: 'FriendZone',
    home: LoginPage(),
  ));
}
