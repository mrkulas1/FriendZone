import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friendzone_flutter/main.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import 'package:friendzone_flutter/pages/login_page/login.dart';
import 'package:friendzone_flutter/pages/profile_page/profile_edit.dart';
import 'package:http/http.dart' as http;
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';

import 'package:friendzone_flutter/main.dart' as app;

void main() {
  group('Test Profile Edit', () {
    //Test 1: test the text is correct
    testWidgets('Testing Profile Text', (tester) async {
      runApp(const MaterialApp(title: 'FriendZone', home: ProfileEditPage()));
      expect(find.text('Introduction'), findsOneWidget);
      expect(find.text('Additional Contact'), findsOneWidget);
      expect(find.text("Edit Profile"), findsOneWidget);
    });

    //Test 2: test the correct number of containers
    testWidgets('Testing Update Button Exists', (tester) async {
      runApp(const MaterialApp(title: 'FriendZone', home: ProfileEditPage()));
      expect(find.byType(Container), findsNWidgets(4));
    });

    //Test 3: test no list view
    testWidgets('Testing Successful Usecase No ListViews', (tester) async {
      runApp(const MaterialApp(title: 'FriendZone', home: ProfileEditPage()));
      expect(find.byType(ListView), findsNothing);
    });
  });
}
