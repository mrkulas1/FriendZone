import 'package:flutter/material.dart';
import 'package:friendzone_flutter/global_header.dart';

class ViewNotfication extends StatefulWidget {
  const ViewNotfication({Key? key}) : super(key: key);

  @override
  _ViewNotfication createState() => _ViewNotfication();
}

class _ViewNotfication extends State<ViewNotfication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      backgroundColor: const Color(0xFFDCDCDC), // Background color
      body: Container(
        child: Text("Hello World"),
      ),
    );
  }
}
