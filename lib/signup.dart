import 'package:bloc/bottomnav.dart';
import 'package:bloc/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ItemData>(
        builder: (context, value, child) {
          return Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                      child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(hintText: "email"),
                        controller: email,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(hintText: "password"),
                        controller: password,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 2, 173, 102),
                          Colors.blue
                        ])),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            onPressed: () async {
                              try {
                                print("workingg");
                                value.signin(
                                  context,
                                  email.text,
                                  password.text,
                                );
                                print("workingg2>>>>.");
                                // if (value.loading1 == true) {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => MyHomePage()));
                                //   print("working");
                                // } else {
                                //   print("not acceptable");
                                // }
                              } catch (e) {
                                print("error>>$e");
                              }
                            },
                            child: Text("signup")),
                      )
                    ],
                  ))
                ],
              ));
        },
      ),
    );
  }
}
