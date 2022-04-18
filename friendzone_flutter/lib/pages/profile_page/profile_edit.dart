import 'package:friendzone_flutter/globals.dart' as globals;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/post_request_functions.dart';
import 'package:friendzone_flutter/models/current_user.dart';
import 'package:friendzone_flutter/models/event.dart';
import 'package:friendzone_flutter/global_header.dart';
import 'package:friendzone_flutter/pages/profile_page/profile.dart';
import 'package:profanity_filter/profanity_filter.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  ProfileEditPageState createState() {
    return ProfileEditPageState();
  }
}

class ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _intro = TextEditingController();
  final TextEditingController _addContact = TextEditingController();
  ProfanityFilter filter = ProfanityFilter();
  @override
  void initState() {
    super.initState();

    if (globals.activeUser == null) {
      return;
    }

    _intro.text = globals.activeUser?.introduction ?? "";
    _addContact.text = globals.activeUser?.contact ?? "";
  }

  final _postFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: SingleChildScrollView(
        child: Form(
          key: _postFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 500,
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
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Color.fromARGB(66, 5, 5, 5),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        validator: (value) {
                          if ((value?.length ?? 0) > 100) {
                            return 'Too long';
                          } else if (filter.hasProfanity(value!)) {
                            return "please keep content clean";
                          }
                          return null;
                        },
                        controller: _intro,
                        decoration: const InputDecoration(
                            labelText: "Introduction",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 80,
                      child: TextFormField(
                        validator: (value) {
                          if ((value?.length ?? 0) > 40) {
                            return 'Too long';
                          } else if (filter.hasProfanity(value!)) {
                            return "please keep content clean";
                          }
                          return null;
                        },
                        controller: _addContact,
                        decoration: const InputDecoration(
                            labelText: "Additional Contact",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3)),
                            )),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_postFormKey.currentState!.validate()) {
                          globals.makeSnackbar(context, "Updating Profile...");
                          Future<CurrentUser> user = updateProfile(
                              globals.activeUser!.email,
                              _intro.text,
                              _addContact.text);
                          user.then((value) {
                            // Preserve token when editing current user
                            String token = globals.activeUser!.token;
                            globals.activeUser = value;
                            globals.activeUser!.token = token;
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProfilePage()));
                          }).catchError((error) {
                            globals.unifiedErrorCatch(context, error);
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            globals.friendzoneYellow),
                      ),
                      child: Container(
                        width: 220,
                        height: 60,
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Update',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
