import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:friendzone_flutter/db_comm/post_functions.dart';

class EventPostPage extends StatelessWidget{
  void click(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 720,
                height: 800,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30,),
                    const Text("Friend Zone",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight:FontWeight.bold
                      ),),
                    const SizedBox(height: 20,),
                    const Text("Create an Event",
                      style: TextStyle(
                        color: Color.fromARGB(66, 5, 5, 5),
                        fontSize: 20,
                      ),),
                    const SizedBox(height: 30,),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        decoration: InputDecoration(
                            labelText: "Event Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        decoration: InputDecoration(
                            labelText: "Location",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        decoration: InputDecoration(
                            labelText: "Number of Slots",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        decoration: InputDecoration(
                            labelText: "Date/Time",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        decoration: InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    Container(
                      width: 260,
                      height: 100,
                      child: const TextField(
                        decoration: InputDecoration(
                            labelText: "Description of Event",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    ElevatedButton(
                    
                            onPressed: () => {
                              // createEvent(userEmail, title, description, location, time, slots, category)
                              // Use for Create Event
                            },
                            style: ButtonStyle(
                            backgroundColor:MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 255, 204, 0)
                            ),
                        
                        ),
                            child: Container(
                          width: 220,
                      height: 60,
                        alignment: Alignment.center,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Create Event',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                          ),
                    const SizedBox(height: 12,),
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
