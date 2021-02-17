import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/user.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../providers/chats.dart';
import 'package:intl/intl.dart';

class RequestScreen extends StatelessWidget {
  static const routeName = "/requests";

  @override
  Widget build(BuildContext context) {
    var db = FirebaseFirestore.instance;
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Requests"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: db
              .collection("Request")
              .orderBy("time", descending: true)
              .snapshots(),
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 25,
                        child: FittedBox(
                          child: Text(
                            DateFormat.Md().format(
                                (docs[index].data()['time'] as Timestamp)
                                    .toDate()),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      title: Text(
                        docs[index].data()['topic'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 26),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            docs[index].data()['personName'],
                            style: TextStyle(color: Colors.black87,fontSize: 20),
                          ),
                          Text(docs[index].data()['description'],
                              style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      trailing: Provider.of<Users>(context, listen: false)
                                  .getUser
                                  .phone ==
                              docs[index].data()['personId']
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                db
                                    .collection("Request")
                                    .doc(docs[index].id)
                                    .delete();
                              },
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.chat,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () async {
                                Toast.show(
                                    "Notification sent successfully!", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                                await Provider.of<Chats>(context, listen: false)
                                    .wantToTalk(
                                        docs[index].data()['personId'],
                                        Provider.of<Users>(context,
                                                listen: false)
                                            .getUser
                                            .phone,
                                        context,
                                        docs[index].data()['topic']);
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
      ),
    );
  }
}
