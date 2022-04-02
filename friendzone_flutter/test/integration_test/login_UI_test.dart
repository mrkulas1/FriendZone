import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friendzone_flutter/main.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/foreign_user.dart';
import 'package:friendzone_flutter/pages/login_page/login.dart';
import 'package:http/http.dart' as http;
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';

import 'package:friendzone_flutter/main.dart' as app;

void main(){
  
  group('Testing Login Class', () {

    //Test 1: 
    testWidgets('Testing Successful Usecase FZ Text', (tester) async {   
      runApp(const MaterialApp(title: 'FriendZone', home: LoginPage()));
      expect(find.text('Friend Zone'), findsOneWidget);
    });
    
    //Test 2:
    testWidgets('Testing FZ Text', (tester) async {   
      runApp(const MaterialApp(title: 'No Account? Sign Up', home: LoginPage()));
      expect(find.text('No Account? Sign Up'), findsOneWidget);
    });

    //Test 3: 
    testWidgets('Testing Successful Usecase No ListViews', (tester) async {   
      runApp(const MaterialApp(title: 'FriendZone', home: LoginPage()));
      expect(find.byType(ListView), findsNothing);
    });
    
      //Test 4: 
    testWidgets('Testing Successful Usecase 6 Containers', (tester) async {   
      runApp(const MaterialApp(title: 'FriendZone', home: LoginPage()));
      expect(find.byType(Container), findsNWidgets(6));
    });

      //Test 5: 
    testWidgets('Testing Successful Usecase SnackBars', (tester) async {   
      runApp(const MaterialApp(title: 'FriendZone', home: LoginPage()));
      expect(find.byType(SnackBar), findsNothing);
    });

      //Test 6
    testWidgets('Testing Successful Usecase SnackBars', (tester) async {   
      runApp(const MaterialApp(title: 'FriendZone', home: LoginPage()));
      expect(find.byType(SnackBar), findsNothing);
    });

    //Test 7
    testWidgets('Testing Successful Usecase SnackBars', (tester) async {   
      runApp(const MaterialApp(title: 'FriendZone', home: LoginPage()));
      expect(find.byType(SnackBar), findsNothing);
    });

  });

}