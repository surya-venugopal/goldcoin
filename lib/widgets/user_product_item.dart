import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/screens/who_viewed.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final imageUrl;
  final String videoUrl;
  UserProductItem(this.id, this.title, this.imageUrl, this.videoUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      subtitle: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Product")
              .doc(id)
              .collection("views")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Row(
              children: [
                Icon(Icons.remove_red_eye),
                SizedBox(
                  width: 15,
                ),
                Text(snapshot.data.docs.length.toString()),
              ],
            );
          }),
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(imageUrl[0]),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(WhoViewedMyProduct.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Confirm"),
                      content: Text("Are you sure you want to delete?"),
                      actions: [
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            try {
                              var db = FirebaseFirestore.instance;
                              var sdb = FirebaseStorage.instance;
                              for(String pic in imageUrl){
                                print(pic.substring(85,111));
                                sdb.ref().child("images").child("+"+pic.substring(85,111)).delete();
                              }
                              if(videoUrl !=null){
                              sdb.ref().child("videos").child("+"+videoUrl.substring(85,111)).delete();}
                              db.collection("Product").doc(id).delete();
                              // await Provider.of<Products>(context,
                              //         listen: false)
                              //     .deleteProduct(
                              //         id,
                              //         Provider.of<Users>(context, listen: false)
                              //             .getUser
                              //             .phone,
                              //         title);
                              Navigator.of(context).pop();
                            } catch (error) {
                              print(error);
                              Navigator.of(context).pop();
                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Slow internet connection!',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
