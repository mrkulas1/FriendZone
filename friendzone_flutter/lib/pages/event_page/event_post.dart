import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
                        color: Color.fromARGB(66, 87, 87, 87),
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
                            labelText: "Date",
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
                            labelText: "Start Time",
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
                            labelText: "End Time",
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
                            labelText: "Description of Event",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(3)),
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Padding(
                      padding:const EdgeInsets.fromLTRB(20, 0, 30, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => {
                              // Use for forget password
                            },
                            child:const Text("Forget Password",
                              style: TextStyle(
                                  color: Colors.black
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Submit form to database
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Color(0xFFFFCC00),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Post Event',
                            style: TextStyle(color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 17 ,),
                    const Text("Or Login using",
                      style: TextStyle(
                          fontWeight: FontWeight.bold
                      ),),
                    const SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            onPressed: () => {
                              // Do something here
                            },
                            icon: const Icon(FontAwesomeIcons.google,color: Colors.black,)
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                   Padding(
                      padding:const EdgeInsets.fromLTRB(10, 0, 10, 0),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => {
                              // Do something here
                            },
                            child:const Text("No Account? Sign Up",
                              style: TextStyle(
                                  color: Colors.black
                              ),
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
    );
  }
}
