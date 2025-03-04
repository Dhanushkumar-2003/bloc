import 'package:bloc/dynamiclink.dart';
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

// import 'package:flutter_tts/flutter_tts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isScrolled = true;
  // Dynamic dd = Dynamic();

  // final FlutterTts flutterTts = FlutterTts();
  // Future<void> speak() async {
  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setPitch(1.0);
  //   await flutterTts.setSpeechRate(0.5);
  //   await flutterTts.speak('HELLO WORLD');
  // }
  final user = FirebaseAuth.instance.currentUser;
  // late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Say 'Hello' to show the button!";
  bool _showButton = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _speech = stt.SpeechToText();
  //   _startListening(); // Start listening immediately
  // }

  // void _startListening() async {
  //   bool available = await _speech.initialize(
  //     onStatus: (status) {
  //       if (status == "notListening") {
  //         _restartListening(); // Restart if it stops
  //       }
  //     },
  //   );

  //   if (available) {
  //     _speech.listen(
  //       onResult: (result) {
  //         setState(() {
  //           istenMode:
  //           stt.ListenMode.dictation;
  //           _text = result.recognizedWords;
  //           if (_text.toLowerCase().contains("hello")) {
  //             _showButton = true;
  //             // Navigator.push(
  //             //     context,
  //             //     MaterialPageRoute(
  //             //         builder: (context) =>
  //             //             MyHomePage())); // Show button when "hello" is detected
  //           }
  //         });
  //   },
  // );
  //   }
  // }

  // void _restartListening() {
  //   Future.delayed(Duration(seconds: 1), () {
  //     if (!_speech.isListening) {
  //       _startListening();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("blog"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // createDynamicLink;
            // // ak();
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
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('profile')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show loader until data arrives
                        }

                        if (!snapshot.hasData ||
                            snapshot.data == null ||
                            !snapshot.data!.exists) {
                          return Text("User data  is loading");
                        }

                        final data =
                            snapshot.data!.data() as Map<String, dynamic>?;

                        if (data == null) {
                          return Text("No user details available");
                        }

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF007AFF), // Blue
                                Color(0xFFFFFFFF), // White
                              ],
                            ),
                          ),
                          height: 150,
                          child: Column(
                            children: [
                              Text(
                                "User Details",
                                style: TextStyle(fontSize: 20),
                              ),
                              Row(
                                children: [
                                  data.containsKey("Image") &&
                                          data["Image"] != null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              data["Image"].toString()),
                                        )
                                      : CircleAvatar(
                                          radius: 40,
                                          backgroundColor:
                                              Colors.grey, // Placeholder
                                          child: Icon(Icons.person,
                                              size: 40, color: Colors.white),
                                        ),
                                  SizedBox(width: 20),
                                  Container(
                                    child: Text(
                                      data.containsKey("username")
                                          ? data["username"]
                                          : "No username",
                                      style: TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
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
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('newdbarticle')
                          .where("userid", isEqualTo: user!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData) {
                          return Center(child: Text("No data available"));
                        }

                        // Access the data from the document
                        final data = snapshot.data!.docs;
                        // print("data>>${data[2]["title"]}");

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
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                // ignore: collection_methods_unrelated_type
                                final item = data[index]['hobbies'];
                                final item2 = data[index]['image'];
                                final item3 = data[index]['audio'];
                                print("userid>>>>>${data[index].id}");
                                return Dismissible(
                                  secondaryBackground:
                                      Icon(Icons.delete_forever_sharp),
                                  background: Icon(Icons.delete),
                                  key: Key(data[index].id),
                                  onDismissed: (direction) {
                                    value.deleteField(data[index].id);
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => cleanview(
                                                  data: item,
                                                  image: item2,
                                                  audio: item3)));
                                    },
                                    child: Card(
                                      child: Container(
                                        height: 70,
                                        padding: EdgeInsets.all(2),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 16.0),
                                        child: Row(
                                          children: [
                                            // Container(
                                            //   color: Colors.blue,
                                            //   child: IconButton(
                                            //       onPressed: () {
                                            //         Navigator.push(
                                            //             context,
                                            //             MaterialPageRoute(
                                            //                 builder: (context) =>
                                            //                     cleanview(
                                            //                         data: item,
                                            //                         image:
                                            //                             item2,
                                            //                         audio:
                                            //                             item3)));

                                            //         value.update(
                                            //             data[index]["title"],
                                            //             data[index]["hobbies"],
                                            //             data[index].id);
                                            //       },
                                            //       icon: Icon(Icons.edit)),
                                            // ),
                                            Image(
                                              width: 70,
                                              image: NetworkImage(data[index]
                                                      ["image"]
                                                  .toString()),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                maxLines: 2,
                                                // maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                data[index]["title"].toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  value.deleteField(
                                                      data[index].id);
                                                },
                                                icon: Icon(Icons.delete))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      }),
                ),
              )
            ],
          ),
        ));
  }
}
