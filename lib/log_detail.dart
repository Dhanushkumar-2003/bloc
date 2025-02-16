import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

// import 'package:google_ml_kit/google_ml_kit.dart';
class log_detail extends StatefulWidget {
  const log_detail({super.key});

  @override
  State<log_detail> createState() => _log_detailState();
}

class _log_detailState extends State<log_detail> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final firestore = FirebaseFirestore.instance;
  final TextEditingController _textController = TextEditingController();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    print("status??$status");
    switch (status) {
      case PermissionStatus.granted:
        requestForPermission();
        break;
      case PermissionStatus.denied:
        print('hjkgjkjgkj');
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
      // TODO: Handle this case.
    }
  }

  Future<void> requestForPermission() async {
    await Permission.microphone.request();
  }

  @override
  void initState() {
    super.initState();
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  String filePath = "";

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(minutes: 30),
      localeId: "en_En",

      // ignore: deprecated_member_use
      cancelOnError: true,
      pauseFor: Duration(seconds: 30),
      partialResults: false,
      listenMode: ListenMode.deviceDefault,
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText
      ..stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      detail.text = _lastWords;
      print("_last wordSS><<$_lastWords");
    });
  }

  Future<void> requestAudioPermission() async {
    print("REQUEST PERMISSION");
    try {
      if (await Permission.audio.isDenied) {
        // print("REQUEST PERMISSION2");
        final dk = await Permission.audio.request();
        print("REQUEST PERMISSION2>>>>>>>>>>>>>>>>>>>>$dk");
      }
    } catch (e) {
      print("errrrror>>$e");
    }
  }

  Future<bool> requestStoragePermissionfor13() async {
    if (await Permission.audio.isGranted) {
      print("GRANTED>>>>>>>>>>>>");
      return true;
      // Permission already granted
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      // _status = "PERMISSION ACCESS";

      print("GRANTED>111111111111111>>>>>>>>>>>>>>>>");
      setState(() {});
      // Permission granted after request
      return true;
    }

    // Open settings if permission is permanently denied
    if (await Permission.manageExternalStorage.isPermanentlyDenied) {
      await openAppSettings();

      print("GRANTED>12222222222222222211>>>>>>>>>>>>>>>>");
    }

    return false; // Permission denied
  }

  Future<void> requestAudioPermission14() async {
    var status = await Permission.audio.status;

    if (!status.isGranted) {
      status = await Permission.audio.request();
    }

    if (status.isGranted) {
      print("Permission Granted! Now you can access audio files.");
    } else {
      print("Permission Denied! The user must allow access.");
    }
  }

  Future<void> pickAudio() async {
    requestAudioPermission14();
    try {
      print("testing>>>>>!");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      print("testing>>>>>2");
      if (result != null) {
        filePath = result.files.single.path!;
        print("Selected Audio File: $filePath");
        AudioPlayer();
        setState(() {});
      } else {
        print("User canceled the picker");
      }
    } catch (e) {
      print("errprrrrrrrrrrr>$e");
    }
  }

  bool playing = true;
  Future<void> playAudio() async {
    try {
      await _audioPlayer.setUrl(filePath);
      _audioPlayer.play();
      setState(() {
        playing = true;
      });
      print("playing>>>>$playing");
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

  TextEditingController detail = TextEditingController();

  TextEditingController title = TextEditingController();

  TextEditingController values = TextEditingController();
  String? _filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton.small(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        backgroundColor: Colors.blue,
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
      body: Consumer<ItemData>(builder: (context, value, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                      hintText: 'enter your title',
                      // border:
                      //     OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(width: 1))),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(hintText: "enter #talk"),
                  controller: values,
                ),
                Text(filePath),
                IconButton(
                    onPressed: () async {
                      value.pickAudio();

                      // value.uploadAudio();
                    },
                    icon: Icon(Icons.audiotrack)),
                // IconButton(onPressed: (){

                // }, icon: icon)
                Text("data${value.filePath}"),

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
                    icon: Icon(Icons.play_circle_outline_rounded)),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // margin: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                  child: TextField(
                    controller: detail,
                    decoration: InputDecoration(
                        prefixIcon: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: CircleAvatar(
                                backgroundImage: value.picke == false
                                    ? null
                                    : FileImage(value.selectImage!),
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
                                      value.getImage();
                                    },
                                    icon: Icon(Icons.camera_alt_outlined)),
                              ),
                            )
                          ],
                        ),
                        hintText: 'enter your movement',
                        // border:
                        //     OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(15)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(width: 1))),
                    maxLines: 10,
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      // saveDetail(detail.text);
                      // save();

                      value.CreateArticle(detail.text, title.text, values.text);
                    },
                    child: Text("save"))
              ],
            ),
          ),
        );
      }),
    );
  }
}
