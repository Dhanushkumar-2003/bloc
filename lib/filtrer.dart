import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedCategory = ''; // Default filter category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('category'))),
      // body: ProductList(title: "title"),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: cros,
            children: [
              Row(
                children: [
                  category(selectedCategory, 'travel', 'travel', context),
                  category(selectedCategory, "education", 'education', context),
                  category(selectedCategory, "health ", 'helath', context),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  category(selectedCategory, "entertainment", "entertainment",
                      context),
                  category(selectedCategory, "polytics", "polytics", context),
                  category(selectedCategory, "sports", "sports", context)
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Text(
                "you can select category depen on your wish",
                style: TextStyle(fontSize: 20),
              ),
              Image(image: AssetImage("images/blog.png"))
            ],
          ),
        ),
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final String title; // Filter criteria

  ProductList({required this.title});
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    print("title>>$title");
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("newdbarticle")
            .where("tag", isEqualTo: title)
            // .where("tag", isEqualTo: user!.uid) // Use dynamic category
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final categoryData = snapshot.data!.docs;
          print("category data>>$categoryData");
          return ListView.builder(
            itemCount: categoryData.length,
            itemBuilder: (context, index) {
              final data = categoryData[index].data();
              return Card(
                child: ListTile(
                  leading: Image.network(data["image"].toString(), width: 70),
                  title: Text(data["title"].toString(),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Widget productlists() {
  return Scaffold();
}

Widget category(String selectedCategory, String category, String text,
    BuildContext context) {
  return GestureDetector(
    onTap: () {
      selectedCategory = category;
      print("selectedcategory>>$selectedCategory");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductList(title: selectedCategory)));
    },
    child: Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: 90,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // color: Colors.blue,
          border: Border(
            left: BorderSide(
              color: Colors.blue,
              width: 3,
            ),
            right: BorderSide(
              color: Colors.blue,
              width: 3,
            ),
            top: BorderSide(
              color: Colors.blue,
              width: 3,
            ),
            bottom: BorderSide(
              color: Colors.blue,
              width: 3,
            ),
          )),
      child: Center(child: Text(text)),
    ),
  );
}
