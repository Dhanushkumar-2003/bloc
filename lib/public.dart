import 'package:bloc/provider.dart';
import 'package:bloc/visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Public_account extends StatefulWidget {
  const Public_account({super.key});

  @override
  State<Public_account> createState() => _Public_accountState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _Public_accountState extends State<Public_account> {
  @override
  Widget build(BuildContext context) {
    final provier = Provider.of<ItemData?>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("public article"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc("publicpage")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return Center(child: Text("No data available"));
            }
            final ak = snapshot.data?.data();

            // print("akkkk>>>${ak![1]["username"]}");
            // Access the data from the document
            // final data = snapshot.data!.data() as Map<String, dynamic>;
            // print("data>>$data");
            // print("akkk>#${ak![0]["hobbies"]}");
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
              child: Consumer<ItemData>(builder: (context, value, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: ak!["hobbies"].length,
                  itemBuilder: (BuildContext context, int index) {
                    // ignore: collection_methods_unrelated_type
                    final item = ak['hobbies'][index];
                    final item2 = ak['image'][index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    cleanview(data: item, image: item2)));
                      },
                      child: Card(
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.all(2),
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  //     StreamBuilder(
                                  //         stream: FirebaseFirestore.instance
                                  //             .collection('profile')
                                  //             .doc()
                                  //             .snapshots(),
                                  //         builder: (context, snapshot) {
                                  //           final data = snapshot.data.;

                                  //           return CircleAvatar(
                                  //             radius: 20,
                                  //             backgroundImage: NetworkImage(
                                  //                 data!["Image"].toString()),
                                  //           );
                                  //         }),

                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        ak["image"][index].toString()),
                                  ),
                                  // Image(
                                  //   width: 70,
                                  //   image: NetworkImage(ak.toString()),
                                  // ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        maxLines: 2,
                                        // maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        // ignore: collection_methods_unrelated_type
                                        ak["title"][index].toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
        ));
  }
}
