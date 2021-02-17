import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/widgets/choose_category.dart';

import '../providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';

import 'add_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProductsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "My Products",
        ),
      ),
      body: Container(
          color: Theme.of(context).primaryColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.all(8),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Product")
                    .where("person_id",
                        isEqualTo: Provider.of<Users>(context, listen: false)
                            .getUser
                            .phone)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final myProducts = snapshot.data.docs;
                  // Provider.of<Products>(context, listen: false)
                  //     .setMyProducts(myProducts);

                  return myProducts.length > 0
                      ? ListView.builder(
                          itemCount: myProducts.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                UserProductItem(
                                  myProducts[index].id,
                                  myProducts[index]['title'],
                                  myProducts[index]['imageUrl'],
                                    myProducts[index]['videoUrl']
                                ),
                                Divider(),
                              ],
                            );
                          })
                      : Center(
                          child: Text(
                              "Add new item by tapping on the button below."));
                }),
          ),
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(context: context,builder: (ctx){
            return ChooseCategory();
          });
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          children: [
            Container(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
