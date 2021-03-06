import 'package:friendzone_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:friendzone_flutter/models/auth_result.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/pages/event_page/event_viewing.dart';

import 'signup.dart';

/// This class handles the login page and allows the user to login if their
/// information is correct. This is the first page users see when they open
/// the app.
class LoginPage extends StatefulWidget {
  final bool tokenLogout;
  const LoginPage({Key? key, this.tokenLogout = false}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  Future<AuthResult>? _futureAuth;

  @override
  void initState() {
    super.initState();

    if (widget.tokenLogout) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => _showTokenAlert(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginFormKey,
        child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/Husky.jpg'),
                      fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      width: 325,
                      //height: 500,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Friend Zone",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Please Login to Your Account",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                return null;
                              },
                              controller: _emailController,
                              decoration: const InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.black,
                                  ),
                                  labelText: "Email Address",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: 260,
                            height: 60,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  suffix: Icon(
                                    FontAwesomeIcons.eyeSlash,
                                    color: Colors.black,
                                  ),
                                  labelText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_loginFormKey.currentState!.validate()) {
                                setState(() {
                                  _futureAuth = authenticate(
                                      _emailController.text,
                                      _passwordController.text);

                                  globals.makeSnackbar(
                                      context, "Logging In...");

                                  _futureAuth?.then((value) {
                                    if (value.success()) {
                                      globals.activeUser = value.getUser();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const EventViewAllPage()));
                                    } else {
                                      globals.makeSnackbar(
                                          context, value.getStatusMessage());
                                    }
                                  }).catchError((error) {
                                    globals.unifiedErrorCatch(context, error);
                                  });
                                });
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  globals.friendzoneYellow),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: 250,
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: 250,
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: globals.friendzoneYellow,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ));
  }

  void _showTokenAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Logged out due to inactivity"),
              content: const Text(
                  "You were inactive in the app for over 30 minutes, "
                  "so you were logged out for security purposes. Please log back "
                  "in to continue."),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        globals.friendzoneYellow),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              ]);
        });
  }
}
