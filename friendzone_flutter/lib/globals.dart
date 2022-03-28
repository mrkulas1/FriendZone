library friendzone_flutter.globals;

import 'package:flutter/material.dart';
import 'package:friendzone_flutter/models/current_user.dart';

CurrentUser? activeUser;

const Color friendzoneYellow = Color.fromARGB(255, 255, 204, 0);

void makeSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
