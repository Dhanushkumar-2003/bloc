import 'package:bloc/visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class visiblescreen extends StatefulWidget {
  final String docid;
  visiblescreen({
    Key? key,
    required this.docid,
  }) : super(key: key);

  @override
  State<visiblescreen> createState() => _visiblescreenState();
}

class _visiblescreenState extends State<visiblescreen> {
  Map<String, dynamic>? documentData;
  void stopSpeaking() async {
    await flutterTts.stop();
    ispause = false;
    setState(() {});
    print("ispause stoptext>>$ispause");
  }

  void speakText(String data) async {
    print("pause f0rspektext>>$ispause");
    // ispause = false;

    await flutterTts.speak(data);
    await flutterTts.setLanguage('ta-IN"');
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(10.0);
    await flutterTts.setPitch(1.0);
    flutterTts.setCompletionHandler(() {
      print('Speech synthesis completed');
    });
    // await flutterTts.pause();
//
    ispause = true;
    setState(() {});
    flutterTts.setErrorHandler((message) {
      print('Error occurred: $message');
    });

    // flutterTts.setLanguageChangedHandler((language) {
    //   print('Language changed to: $language');
    // });
  }

  // Future<void> generateAndShareDynamic

  @override
  void initState() {
    fetchData();
    // initDynamicLinks();
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('newdbarticle') // Change to your Firestore collection
          .doc(widget.docid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          documentData = docSnapshot.data() as Map<String, dynamic>?;
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("your article"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ispause = !ispause;
            if (ispause == false) {
              stopSpeaking();
            } else if (ispause == true) {
              speakText(documentData!["hobbies"]);
            }
            // ispause == false ? speakText(widget.data) :

            print("ispause>>>>$ispause");
            setState(() {});
          },
          child: ispause == true
              ? Icon(Icons.mic_none_sharp)
              : Icon(Icons.mic_off_outlined),
        ),
        body: documentData == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: double.infinity,
                  // color: Colors.orange,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          color: Colors.blue,
                          // height: 200,
                          width: double.infinity,
                          // margin: EdgeInsets.only(left: 10, right: 0),
                          child: Image(
                              height: 200,
                              fit: BoxFit.cover,
                              // width: double.infinity,
                              image: NetworkImage(
                                  documentData!["image"] ?? "null")),
                        ),
                        Container(
                          // alignment: Alignment(15, 10),
                          child: Text(documentData!["hobbies"] ??
                              "no value".toString()),
                        ),
                      ]),

                  // Positioned(
                  //   left: 10,
                  //   top: 0,
                  //   bottom: 80,
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(22.0),
                  //     child: Image(
                  //         width: 100,
                  //         height: 150,
                  //         fit: BoxFit.cover,
                  //         image: NetworkImage(widget.image.toString())),
                  //   ),
                  // ),

                  // CircleAvatar(
                  //   radius: 80,
                  //   backgroundImage: NetworkImage(widget.image.toString()),
                  // ),
                ),
              ));
  }
}
