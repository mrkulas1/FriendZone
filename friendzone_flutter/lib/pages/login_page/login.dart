import 'package:friendzone_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:friendzone_flutter/models/auth_result.dart';
import 'package:friendzone_flutter/pages/event_page/event_post.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/pages/event_page/event_viewing.dart';

import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  Future<AuthResult>? _futureAuth;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/Husky.jpg'), fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 60,
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => {
                                // TODO: Nothing for now, maybe comment out
                              },
                              child: const Text(
                                "Forget Password",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_loginFormKey.currentState!.validate()) {
                            setState(() {
                              _futureAuth = authenticate(_emailController.text,
                                  _passwordController.text);

                              globals.makeSnackbar(context, "Logging In...");

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
                                globals.makeSnackbar(context, error.toString());
                              });
                            });
                          }
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 17,
                      ),
                      const Text(
                        "Or Login using",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () => {
                                    // TODO: other auth? maybe comment out for now
                                  },
                              icon: const Icon(
                                FontAwesomeIcons.google,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()))
                              },
                              child: const Text(
                                "No Account? Sign Up",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.web_rounded),
          backgroundColor: globals.friendzoneYellow,
          onPressed: () {
            authenticate("test@mtu.edu", "Password123").then((value) {
              globals.activeUser = value.getUser();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const EventViewAllPage()));
            });
          },
        ),
      ),
    );
  }
}
