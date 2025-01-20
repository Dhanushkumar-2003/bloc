import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class cleanview extends StatefulWidget {
  final String data;
  final String image;

  cleanview({Key? key, required this.data, required this.image})
      : super(key: key);

  @override
  State<cleanview> createState() => _cleanviewState();
}

class _cleanviewState extends State<cleanview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("your article"),
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
                  image: NetworkImage(widget.image.toString())),
            ),
            Container(
              // alignment: Alignment(15, 10),
              child: Text(widget.data.toString()),
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
      ),
    );
  }
}
