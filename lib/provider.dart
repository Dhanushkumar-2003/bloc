// import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import 'package:bloc/bottomnav.dart';
import 'package:bloc/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ItemData extends ChangeNotifier {
  File? _selectedImage;
  File? get selectImage => _selectedImage;
  bool uploaded = false;
  bool _picke = false;
  bool get picke => _picke;
  String _filePath = "";
  String get filePath => _filePath;
  bool _loading = false;
  bool get loading => _loading;
  bool _loading1 = false;
  bool get loading1 => _loading;
  File? _selectedImage1;
  File? _file;
  File? get file => _file;

  File? get selectImage1 => _selectedImage;
  String _downloadUrlAudio = "";
  String get downloadUrlAudio => _downloadUrlAudio;
  String _getlink = "";
  String get getlink => _getlink;
  bool get complete => _complete;
  bool _complete = false;
  FilePickerResult? _videofile;
  FilePickerResult? get vidoefile => _videofile;

// <<<<<<<<get image for uploading article>>>>>>>>>>>>>>
  Future getImage() async {
    final _picker = ImagePicker();
    _picke = true;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final ak = image;
    _selectedImage = File(ak!.path.toString());
    // _picke = false;

    notifyListeners();
  }

  void playaudio() async {
    // var  dk = await AudioPlayer().play(_file!.path );
    // _file!.path);
    // ignore: avoid_print
    // print("dkkkkk$dk");
  }
  Future pickAudio() async {
    // requestAudioPermission14();
    try {
      print("testing>>>>>!");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      print("testing>>>>>2");
      if (result != null) {
        _filePath = result.files.single.path!;
        print("Selected Audio File: $_filePath");
        // AudioPlayer();
      } else {
        print("User canceled the picker");
      }
    } catch (e) {
      print("errprrrrrrrrrrr>$e");
    }
    notifyListeners();
  }

  Future<void> uploaDdAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Pick audio files
    );

    if (result != null) {
      _file = File(result.files.single.path!);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      print("STRING FILENAME>>$fileName");

      try {
        print(' working>>>>>.>>');
        // Upload audio to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('audios/$fileName.mp3') // Change extension as needed
            .putFile(_file!);

        print(' working222$snapshot>>>>>.>>');
        // Get the download URL
        _downloadUrlAudio = await snapshot.ref.getDownloadURL();

        // Store the download URL in Firestore

        print("Audio uploaded successfully: $_downloadUrlAudio");
      } catch (e) {
        print("Upload failed: $e");
      }
    }
    notifyListeners();
  }

  Future<void> deleteField(
    String docId,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('newdbarticle')
          .doc(docId)
          .delete();
      print("Field deleted successfully");
    } catch (e) {
      print("Error deleting field: $e");
    }
    notifyListeners();
  }

  Future update(
    String title,
    String detail,
    String userid,
  ) async {
    await FirebaseFirestore.instance.collection('newdbarticle').doc().update({
      'title': title,
      'hobbies': detail,

      'userid': userid
      // 'loginCount': FieldValue.increment(1),
    });
  }

  Future<void> CreateArticle(
      BuildContext context, String detail, String title, String value) async {
    final user = FirebaseAuth.instance.currentUser;

    // // Public getter to access the image.
    SpinKitFadingCircle(
      size: 200,
      color: Colors.blueAccent,
    );
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'uploading',
      text: 'wait for few second',
    );
    print("step11>>>");
    if (user != null) {
      // final _userRef = FirebaseFirestore.instance.collection('users');
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('log_image/$imageName.jpg');
      print("step2>>>>>");
      // Upload file
      var uploadTask = storageRef.putFile(_selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      print("step333>");
      await FirebaseFirestore.instance.collection('newdbarticle').doc().set({
        'title': title,
        'hobbies': detail,
        'image': downloadUrl,
        'tag': value,
        'audio': _filePath,
        'userid': user.uid
        // 'loginCount': FieldValue.increment(1),
      });

      // filePath == false;
    }

    uploaded = true;
    _picke = false;
    if (uploaded == true) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'sucessfully upload your article',
        text: 'check profile page',
        confirmBtnText: "ok",
        onConfirmBtnTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      );
    }
    uploaded = false;
    print("step444");

    notifyListeners();
  }

// <<<< gt image form updatig user profile>>>>>>
  Future getImage1() async {
    final _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final profileimage = image;

    _selectedImage = File(profileimage!.path.toString());

    notifyListeners();
  }

//<<<<< creare sigin page for user>>>>>>>>>>>//
  Future uploadProfile(String email, String password, String username) async {
    try {
      _loading = true;
      print("step1>>>");
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("SIGININ$userCredential");
      final firestore = FirebaseFirestore.instance;
      User? user = FirebaseAuth.instance.currentUser;
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('profiel_image/$imageName.jpg');
      print("storagee ref>>$storageRef");
      var uploadTask = storageRef.putFile(_selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print("doewnloadurl>>$downloadUrl");
      await firestore.collection("profile").doc(userCredential.user!.uid).set({
        "username": username,
        // Add image reference to document
        "Image": downloadUrl.toString()
      });

      _loading = false;
      print("last step");
      //
    } catch (e) {
      print("error>>>>$e");
    }

    notifyListeners();
  }

  void signin(BuildContext context, String email, String password) async {
    print("loading>>>>>>>>>.11");
    print("loading>>>>>>>>>.11");

    _loading1 = true;
    print("loading11>>$_loading1");
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    print("loading>>>>>>>>>.12");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
    // _loading1 = false;
    // notifyListeners();
    print("loading11>>$_loading1");
  }

  Future pickvideo() async {
    final ImagePicke = ImagePicker();
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      // final String storageId = (millSeconds.toString() + uid);
      final String today = ('$month-$date');

      _videofile = (await ImagePicke.pickVideo(source: ImageSource.gallery))
          as FilePickerResult?;
      print("vidoefile>>$_videofile");
      final ref = FirebaseStorage.instance
          .ref()
          .child("video")
          .child(today)
          .child(millSeconds.toString());
      final uploadTask = ref.putFile(File(file!.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      final downloadURL = await taskSnapshot.ref.getDownloadURL();
      // Uri downloadUrl =await (await uploadTask).downloadUrl;

      final String url = downloadURL.toString();

      print("url>>>>$url");
    } catch (error) {
      print(error);
    }
  }
}
