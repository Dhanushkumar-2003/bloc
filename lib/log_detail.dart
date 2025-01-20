import 'dart:io';

import 'package:bloc/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class log_detail extends StatefulWidget {
  const log_detail({super.key});

  @override
  State<log_detail> createState() => _log_detailState();
}

class _log_detailState extends State<log_detail> {
  final firestore = FirebaseFirestore.instance;

  // Future save() async {
  //   try {
  //     // Generate unique image name

  //     // Use a batch to update Firestore
  //     await firestore.collection("log_detail").doc(user!.uid).set({
  //       "username": detail.text,
  //       "Image": downloadUrl.toString(),
  //     });

  //     print("succc>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  //     // Commit the batch
  //     // await batch.commit();

  //     print("succc>>>>>>>>>>>>>>>>>>>>>>>>>>11>");
  //     print("Data added successfully!");
  //   } catch (e) {
  //     print('Failed to add data: $e');
  //   }
  // }

  TextEditingController detail = TextEditingController();

  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

                      value.updateUserProfile(detail.text, title.text);
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
