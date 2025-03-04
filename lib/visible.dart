import 'dart:io';

import 'package:bloc/dynamiclink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import 'package:share_plus/share_plus.dart';

class cleanview extends StatefulWidget {
  final String data;
  final String image;
  final String audio;

  cleanview(
      {Key? key, required this.data, required this.image, required this.audio})
      : super(key: key);

  @override
  State<cleanview> createState() => _cleanviewState();
}

bool ispause = false;

FlutterTts flutterTts = FlutterTts();

Future<void> configureTts() async {}

class _cleanviewState extends State<cleanview> {
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
    // initDynamicLinks();
    // TODO: implement initState
    super.initState();
  }

  bool playing = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  Future playAudio() async {
    try {
      await _audioPlayer.setUrl(widget.audio);
      _audioPlayer.play();
      setState(() {
        playing = true;
      });
      print("play function>>>>$playing");
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        playing = false;
      });
      print("pause>>>>$playing");
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("your article"),
        actions: [
          IconButton(
              onPressed: () async {
                // generateAndShareDynamicLink();
                // shareDocumentLink();
                // ignore: deprecated_member_use
                FirebaseDynamicLinks.instance.onLink;

//To Handle pending dynamic links add following lines
                final PendingDynamicLinkData? data =
                    await FirebaseDynamicLinks.instance.getInitialLink();
                final Uri deepLink = data!.link;

                if (deepLink != null) {
                  String id = deepLink.queryParameters['id']!;
                  print(id);
                }
              },
              icon: Icon(Icons.share))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ispause = !ispause;
          if (ispause == false) {
            stopSpeaking();
          } else if (ispause == true) {
            speakText(widget.data);
          }
          // ispause == false ? speakText(widget.data) :

          print("ispause>>>>$ispause");
          setState(() {});
        },
        child: ispause == true
            ? Icon(Icons.mic_none_sharp)
            : Icon(Icons.mic_off_outlined),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          // color: Colors.orange,
          margin: EdgeInsets.only(left: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  image: NetworkImage(widget.image)),
            ),
            Container(
              // alignment: Alignment(15, 10),
              child: Text(widget.data.toString()),
            ),
            Container(
              // alignment: Alignment(15, 10),
              child: Text(widget.audio.toString() ?? ""),
            ),
            IconButton(
                onPressed: () async {
                  playing != playing;
                  playing == false ? playAudio() : pause();
                  // playing != playing;
                  setState(() {
                    print("iconplay>>>$playing");
                  });
                  // value.playaudio();
                },
                icon: playing == false
                    ? Icon(Icons.play_arrow)
                    : Icon(Icons.pause)),
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
      ),
    );
  }
}
