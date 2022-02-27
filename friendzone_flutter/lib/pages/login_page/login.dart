import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginApp extends StatelessWidget{
  void click(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage (
              image: AssetImage(
                  'images/Husky.jpg'
                  ),
              fit: BoxFit.cover
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox(height: 60,),
              Container(
                width: 325,
                height: 470,
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
                    const SizedBox(height: 10,),
                    const Text("Please Login to Your Account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),
                    const SizedBox(height: 30,),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        decoration: InputDecoration(
                            suffix: Icon(FontAwesomeIcons.envelope,color: Color(0xFFFFCC00),),
                            labelText: "Email Address",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            )
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Container(
                      width: 260,
                      height: 60,
                      child: const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            suffix: Icon(FontAwesomeIcons.eyeSlash,color: Color(0xFFFFCC00),),
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            )
                        ),
                      ),
                    ),
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
                          child: Text('Login',
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
