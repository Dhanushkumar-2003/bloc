import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ItemData extends ChangeNotifier {
  File? _selectedImage; // Private variable to store the image.

  File? get selectImage => _selectedImage;
  bool _picke = false;
  bool get picke => _picke;

  bool _loading = false;
  bool get loading => _loading;
  File? _selectedImage1;

  File? get selectImage1 => _selectedImage;
  Future getImage() async {
    final _picker = ImagePicker();
    _picke = true;
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final ak = image;
    _selectedImage = File(ak!.path.toString());

    notifyListeners();
  }

  Future<void> updateUserProfile(String detail, String title) async {
    final user = FirebaseAuth.instance.currentUser;
    // Public getter to access the image.

    if (user != null) {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final _userRef = FirebaseFirestore.instance.collection('users');
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef =
          FirebaseStorage.instance.ref().child('log_image/$imageName.jpg');

      // Upload file
      var uploadTask = storageRef.putFile(_selectedImage!);
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      try {
        await userRef.set({
          'lastUpdated': FieldValue.serverTimestamp(),
          'preferences': {'darkMode': true},
        }, SetOptions(merge: true));
        await FirebaseFirestore.instance
            .collection('users')
            .doc('publicpage')
            .set({
              
          'lastUpdated': FieldValue.serverTimestamp(),
          'preferences': {'darkMode': true},
        }, SetOptions(merge: true));
        await FirebaseFirestore.instance
            .collection('users')
            .doc('publicpage')
            .update({
          'title': FieldValue.arrayUnion([title]),
          'hobbies': FieldValue.arrayUnion([detail]),
          'image': FieldValue.arrayUnion([downloadUrl]),
          'loginCount': FieldValue.increment(1),
        });

        await userRef.update({
          'title': FieldValue.arrayUnion([title]),
          'hobbies': FieldValue.arrayUnion([detail]),
          'image': FieldValue.arrayUnion([downloadUrl]),
          'loginCount': FieldValue.increment(1),
        });

        _picke = false;
        print('akk>>>>>>>>');
        print('User profile updated successfully');
      } catch (e) {
        print('Error updating user profile: $e');
      }
    }
    notifyListeners();
  }

  Future getImage1() async {
    final _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final ak = image;

    _selectedImage = File(ak!.path.toString());
    notifyListeners();
  }

  Future uploadfirebase1(String email, String password, String username) async {
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

  // void updateUserProfile1(String text, String text2, String text3) {}
}
