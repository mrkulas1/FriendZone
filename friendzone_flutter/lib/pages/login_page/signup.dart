import 'package:friendzone_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/pages/event_page/event_viewing.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'login.dart';

/// This class allows users to fill in their information and create an account
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _signupFormKey = GlobalKey<FormState>();
  ProfanityFilter filter = ProfanityFilter();
  Future<CurrentUser>? _futureUser;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signupFormKey,
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
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a first name';
                            } else if (filter.hasProfanity(value)) {
                              return 'Enter a FriendZone appropriate name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.keyboard,
                                color: Colors.black,
                              ),
                              labelText: "First Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a last name';
                            } else if (filter.hasProfanity(value)) {
                              return 'Enter a FriendZone appropriate name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.keyboard,
                                color: Colors.black,
                              ),
                              labelText: "Last Name",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _introController,
                          validator: (value) {
                            if (filter.hasProfanity(value!)) {
                              return 'Keep content appropriate';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.paragraph,
                                color: Colors.black,
                              ),
                              labelText: "Short Introduction",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _contactInfoController,
                          validator: (value) {
                            if (value != null && value.length > 40) {
                              return 'Contact Info must be under 40 characters';
                            } else if (filter.hasProfanity(value!)) {
                              return 'Keep your contact info appropriate';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.addressBook,
                                color: Colors.black,
                              ),
                              labelText: "Other Contact Info",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (value.length > 100) {
                              return 'Email must be less than 100 characters';
                            }
                            if (!value.endsWith('@mtu.edu')) {
                              return 'Please enter an MTU email';
                            } else if (filter.hasProfanity(value)) {
                              return 'Keep content appropriate';
                            }
                            return null;
                          },
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
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be greater than 8 characters';
                            }
                            if (value.length > 100) {
                              return 'Password must be less than 100 characters';
                            } else if (filter.hasProfanity(value)) {
                              return 'Keep content appropriate';
                            }
                            return null;
                          },
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
                        height: 12,
                      ),
                      SizedBox(
                        width: 260,
                        height: 60,
                        child: TextFormField(
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords must match';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              suffix: Icon(
                                FontAwesomeIcons.eyeSlash,
                                color: Colors.black,
                              ),
                              labelText: "Confirm Password",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_signupFormKey.currentState!.validate()) {
                            setState(() {
                              _futureUser = register(
                                  _emailController.text,
                                  _passwordController.text,
                                  "${_firstNameController.text} ${_lastNameController.text}",
                                  _introController.text,
                                  _contactInfoController.text);

                              globals.makeSnackbar(context, "Registering...");

                              _futureUser?.then((value) {
                                globals.activeUser = value;
                                ScaffoldMessenger.of(context).clearSnackBars();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const EventViewAllPage()));
                              }).catchError((error) {
                                globals.unifiedErrorCatch(context, error);
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
                              'Sign up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()))
                              },
                              child: const Text(
                                "Have an account? Log in",
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
      ),
    );
  }
}
