import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/providers/chats.dart';
import 'package:stocklot/providers/user.dart';

import 'chat_screen.dart';

class WhoViewedMyProduct extends StatelessWidget {
  static const routeName = "/who-viewed";

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var size = MediaQuery.of(context).size;
    var id = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Views"),
      ),
      body: StreamBuilder(
        stream:
            db.collection("Product").doc(id).collection("views").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var docs = snapshot.data.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (_, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(docs[index].data()['name']),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(docs[index].data()['rating'].toString())
                      ],
                    ),
                    trailing: docs[index].id ==
                            Provider.of<Users>(context).getUser.phone
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.message,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              var doc = await db
                                  .collection("User")
                                  .doc(docs[index].id)
                                  .get();
                              Navigator.of(context)
                                  .pushNamed(ChatScreen.routeName, arguments: {
                                "id": docs[index].id,
                                "name": doc.data()['name'],
                                "dp": doc.data()['dp'],
                                "userVideoId": doc.data()['userVideoId']
                              });
                            },
                          ),
                  ),
                  Divider(
                    thickness: 1,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
