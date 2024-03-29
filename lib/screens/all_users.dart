import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/screens/search_users.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';

class AllUsers extends StatelessWidget {
  static const routeName = "/all-users";

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchUser.routeName);
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: db.collection("User").orderBy("name").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var docs = snapshot.data.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: size.width * 0.2,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: docs[index].data()['dp'] != null &&
                                    docs[index].data()['dp'] != ""
                                ? NetworkImage(docs[index].data()['dp'])
                                : null,
                            child: docs[index].data()['dp'] != null &&
                                    docs[index].data()['dp'] != ""
                                ? null
                                : Text(
                                    docs[index].data()['name'][0],
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                          SizedBox(width: 10),
                          docs[index].data()['isVerified'] != null &&
                                  docs[index].data()['isVerified'] == true
                              ? Icon(
                                  Icons.verified,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Container()
                        ],
                      ),
                    ),
                    title: Text(
                      docs[index].data()['name'],
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(docs[index].data()['rating'].toString()),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ],
                        ),
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
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ChatScreen.routeName, arguments: {
                                "id": docs[index].id,
                                "name": docs[index].data()['name'],
                                "dp": docs[index].data()['dp'],
                              });
                            },
                          ),
                  ),
                  Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }
}
