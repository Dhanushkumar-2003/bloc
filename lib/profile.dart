import 'package:bloc/log_detail.dart';
import 'package:bloc/provider.dart';
import 'package:bloc/visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isScrolled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("blog"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => log_detail()));
          },
          isExtended: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          label: const Text('Compose'),
          icon: const Icon(Icons.edit_outlined),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 115, 181, 246), // Blue
                Color(0xFFFFFFFF), // White
              ],
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Center(
                  child: Container(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('profile')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        print("fdatat>>$data");
                        if (snapshot.hasData) {
                          // The following doesn't work
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  // Color(0xFFFFFFFF),
                                  Color(0xFF007AFF), // Blue
                                  Color(0xFFFFFFFF), // White
                                ],
                              ),
                            ),
                            height: 150,
                            child: Column(
                              children: [
                                Text(
                                  "userdetail",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                          data!["Image"].toString()),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      child: Text(
                                        data["username"],
                                        style: TextStyle(fontSize: 30),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text('Error');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "your article",
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 196, 201, 206),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Center(child: Text("No data available"));
                      }

                      // Access the data from the document
                      final data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      print("data>>$data");

                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              // Color(0xFFFFFFFF),
                              Color(0xFF007AFF), // Blue
                              Color(0xFFFFFFFF), // White
                            ],
                          ),
                        ),
                        child: Consumer<ItemData>(
                            builder: (context, value, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data["title"].length,
                            itemBuilder: (BuildContext context, int index) {
                              // ignore: collection_methods_unrelated_type
                              final item = data['hobbies'][index];
                              final item2 = data['image'][index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => cleanview(
                                              data: item, image: item2)));
                                },
                                child: Card(
                                  child: Container(
                                    height: 70,
                                    padding: EdgeInsets.all(2),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Image(
                                          width: 70,
                                          image: NetworkImage(
                                              data["image"][index].toString()),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            maxLines: 2,
                                            // maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            data["title"][index].toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
