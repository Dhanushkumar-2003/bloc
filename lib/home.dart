import 'dart:io';

import 'package:bloc/bottomnav.dart';
import 'package:bloc/profile.dart';
import 'package:bloc/provider.dart';
import 'package:bloc/signup.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ImagePicker _picker = ImagePicker();

  final firestore = FirebaseFirestore.instance;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  // Future sigin() async {
  //   UserCredential userCredential = await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //           email: email.text, password: password.text);
  //   print("SIGININ$userCredential");
  //   User? user = FirebaseAuth.instance.currentUser;
  //   print(user!.displayName);
  // }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ItemData>(builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: value.loading == true
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: CircleAvatar(
                              backgroundImage: value.selectImage1 != null
                                  ? FileImage(value.selectImage1!)
                                  : null,
                              radius: 50,
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            right: -3,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(45)),
                              child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    value.getImage1();
                                  },
                                  icon: Icon(Icons.camera_alt_outlined)),
                            ),
                          )
                        ],
                      ),
                      TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a  username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(label: Text('username')),
                      ),
                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)) {
                            return 'Enter a valid email!';
                          }
                        },
                        decoration: InputDecoration(label: Text('email')),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a  password contain 6 digit!';
                          }
                          return null;
                        },
                        controller: password,
                        decoration: InputDecoration(label: Text('password')),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 2, 173, 102),
                          Colors.blue
                        ])),
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                value.uploadProfile(
                                    email.text, password.text, username.text);
                                if (value.loading == false) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()));
                                } else {
                                  print("not acceptable");
                                }
                              }
                            }
                            //  value.uploadfirebase1(
                            //       email.text, password.text, username.text);
                            //   if (value.loading == false) {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => MyHomePage()));
                            //   } else {
                            //     print("not acceptable");
                            //   }
                            // },
                            ,
                            child: Text("sign in")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(
                            height: 2,
                            color: Colors.black,
                          ),
                          Text("or"),
                          Divider(
                            height: 2,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                              // value.signin(
                              //   email.text,
                              //   password.text,
                              // );
                              // if (value.loading1 == false) {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => MyHomePage()));
                              // } else {
                              //   print("not acceptable");
                              // }
                            },
                            child: Text("log in")),
                      )
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
