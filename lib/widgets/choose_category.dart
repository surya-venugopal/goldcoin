import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/screens/add_product_screen.dart';

class ChooseCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Category"),
      content: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Categories")
            .doc("categories")
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var doc = snapshot.data.data();
          var keys = doc.keys.toList(growable: false)
            ..sort((k1, k2) => doc[k1].compareTo(doc[k2]));
          return Categories(keys);
        },
      ),
    );
  }
}

class Categories extends StatefulWidget {
  final keys;
  const Categories(this.keys);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String whereToGo = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        ...widget.keys.map((key) {
          return Row(
            children: [
              Radio(
                value: key,
                groupValue: whereToGo,
                onChanged: (value) {
                  setState(() {
                    whereToGo = value;
                    Navigator.of(context)
                        .pushReplacementNamed(AddProduct.routeName, arguments: value);
                  });
                },

              ),
              Text(key),
            ],
          );
        })
      ],
    ));
  }
}
