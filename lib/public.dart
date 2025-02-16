import 'package:bloc/dynamiclink.dart';
import 'package:bloc/profile.dart';
import 'package:bloc/provider.dart';
import 'package:bloc/visible.dart';
import 'package:bloc/visiblescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Public_account extends StatefulWidget {
  const Public_account({super.key});

  @override
  State<Public_account> createState() => _Public_accountState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _Public_accountState extends State<Public_account> {
  Future docid() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('newdbarticle').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      String docId = doc.id; // ✅ Get document ID
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      print('Document ID: $docId, Data: $data');
    }
  }

  //
  void initDynamicLinks() async {
    print("stepi is rrunnig");
    // ignore: deprecated_member_use
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
      final Uri deepLink = data.link;
      print("step2 is running>>>>");

      print("step2 is running>>>>$deepLink");
      if (deepLink.queryParameters.containsKey('docId')) {
        String? docId = deepLink.queryParameters['docId'];
        print("documentid>>>>>>>>>>>>>>>>>>$docId");
        if (docId != null) {
          print("navigating");
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => cleanview(
          //               data: '',
          //               image: '',
          //             )));
          // Navigator.push(
          // context, MaterialPageRoute(builder: (context) => Profile()));
          // Navigate to the document screen with the docId
          // Navigator.pushNamed(context, '/document', arguments: docId);
        }
      }
      print("skip the step three");
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  void initDynamicLink() async {
    print("Step 1: Listening for dynamic links...");

    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
      final Uri deepLink = data.link;
      print("Step 2: Deep link received - $deepLink");

      // Extract query parameters
      if (deepLink.queryParameters.containsKey('docId') &&
          deepLink.queryParameters.containsKey('image')) {
        String? docId = deepLink.queryParameters['docId'];
        String? imageUrl = deepLink.queryParameters['image'];

        print("Extracted docId: $docId");
        print("Extracted imageUrl: $imageUrl");

        if (docId != null && imageUrl != null) {
          print("Navigating to CleanView with extracted data...");

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => cleanview(
          //       data: docId,
          //       image: imageUrl,
          //     ),
          //   ),
          // );
        }
      }
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });

    // Handle deep link when app is launched from terminated state
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      print("Step 3: App opened from terminated state - $deepLink");

      if (deepLink.queryParameters.containsKey('docId') &&
          deepLink.queryParameters.containsKey('image')) {
        String? docId = deepLink.queryParameters['docId'];
        String? imageUrl = deepLink.queryParameters['image'];

        if (docId != null && imageUrl != null) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => cleanview(
          //       data: docId,
          //       image: imageUrl,
          //     ),
          //   ),
          // );
        }
      }
    }
  }

  void _handleDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    print("working>>>>>>>>");
    // Handle when app is opened from a terminated state
    final PendingDynamicLinkData? initialLink =
        await dynamicLinks.getInitialLink();
    if (initialLink != null) {
      print("steppp@2>>>>>>>>>>>>");

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Profile()));
      // _navigateToScreen(initialLink.link);
    }

    // Handle when app is in the background or foreground
    dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLink) {
      if (dynamicLink.link != null) {
        // Navigator.push(
        // context, MaterialPageRoute(builder: (context) => Profile()));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => cleanview(
        //               data: '',
        //               image: '',
        //             )));
        // _navigateToScreen(dynamicLink.link);
      }
    }).onError((error) {
      print("Dynamic Link Failed: $error");
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  void shareDocumentLink(
    String docId,
  ) async {
    String link = await createDynamicLink(docId);
    Share.share('Check out this document: $link');
  }

  //another linkk??
  void anotherinitDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData data) {
      handleDynamicLink(data);
    }).onError((error) {
      print('Dynamic Link Error: $error');
    });

    // Handle when app is launched from a dynamic link
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      handleDynamicLink(initialLink);
    }
  }

  /// Handle navigation when a dynamic link is opened
  void handleDynamicLink(PendingDynamicLinkData data) {
    final Uri deepLink = data.link;
    print("Deep Link: $deepLink");

    if (deepLink.queryParameters.containsKey('docid')) {
      String? docId = deepLink.queryParameters['docid'];
      print("DOCIDDDD>>>$docId");
      if (docId != null) {
        print("navigating>>>>>>>>>>");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => visiblescreen(docid: docId)),
        );
      }
    }
  }

  @override
  void initState() {
    // initDynamicLink();
    anotherinitDynamicLinks();
    // _handleDynamicLinks();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provier = Provider.of<ItemData?>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("public article"),
          actions: [
            TextButton(
                onPressed: () {
                  initDynamicLinks();
                },
                child: Text("share"))
          ],
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('newdbarticle').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return Center(child: Text("No data available"));
            }
            dynamic CollectionData = snapshot.data!.docs;
            String docId = CollectionData[0].id;
            print("docid>>$docId");
            print("data>>>${snapshot.data!.docs}");
            //  snapshot.data?.data();

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
                  itemCount: CollectionData!.length,
                  itemBuilder: (BuildContext context, int index) {
                    // ignore: collection_methods_unrelated_type
                    final item = CollectionData[index]['hobbies'];
                    final item2 = CollectionData[index]['image'];
                    final item3 = CollectionData[index]['audio'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => cleanview(
                                      data: item,
                                      image: item2,
                                      audio: item3,
                                    )));
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
                                        CollectionData[index]["image"]
                                            .toString()),
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

                                        CollectionData[index]["title"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: IconButton(
                                          onPressed: () {
                                            shareDocumentLink(
                                                CollectionData[index].id);
                                          },
                                          icon: Icon(Icons.share)),
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
