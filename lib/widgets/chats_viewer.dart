import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/chats.dart';
import '../providers/user.dart';
import '../screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatViewer extends StatefulWidget {
  static const routeName = '/chats';
  @override
  _ChatViewerState createState() => _ChatViewerState();
}

class _ChatViewerState extends State<ChatViewer> {
  bool showFav = false;

  @override
  Widget build(BuildContext context) {
    var myId = Provider.of<Users>(context, listen: false).getUser.phone;
    var db = FirebaseFirestore.instance;
    CollectionReference stream =
        db.collection("User").doc(myId).collection("friends");
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: showFav
                ? stream.where("isStarred", isEqualTo: true).snapshots()
                : stream.orderBy("time", descending: true).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var chats = snapshot.data.docs;
              Provider.of<Chats>(context).setChats(chats);
              return chats.length == 0
                  ? Center(
                      child: Text("No chats found!"),
                    )
                  : ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (_, index) {
                        // var time = (chats[index]['time'] as Timestamp).toDate();
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                var doc = await db
                                    .collection("User")
                                    .doc(chats[index]['personId'])
                                    .get();

                                return Navigator.of(context).pushNamed(
                                    ChatScreen.routeName,
                                    arguments: {
                                      "id": chats[index]['personId'],
                                      "name": chats[index]['personName'],
                                      "dp": doc.data()['dp'],
                                      "userVideoId":doc.data()['userVideoId'],
                                    });
                              },
                              leading: CircleAvatar(
                                child: Text(
                                  chats[index]['personName'][0],
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              title: Text(chats[index]['personName']),
                              // subtitle: Text(
                              //   "${time.hour}:${time.minute} - ${time.day}/${time.month}",
                              //   style: TextStyle(
                              //       color: Theme.of(context).accentColor),
                              // ),
                              trailing: IconButton(
                                icon: Icon(
                                  chats[index].data()['isStarred'] != null
                                      ? chats[index]['isStarred']
                                          ? Icons.star
                                          : Icons.star_border
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  if (chats[index].data()['isStarred'] !=
                                      null) {
                                    bool isStarred = chats[index]['isStarred'];
                                    db
                                        .collection("User")
                                        .doc(myId)
                                        .collection("friends")
                                        .doc(chats[index]['personId'])
                                        .update({"isStarred": !isStarred});
                                  } else {
                                    db
                                        .collection("User")
                                        .doc(myId)
                                        .collection("friends")
                                        .doc(chats[index]['personId'])
                                        .update({"isStarred": true});
                                  }
                                },
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      });
            },
          ),
          Positioned(
            bottom: 10,
            left: 20,
            child: FlatButton(
              onPressed: () {
                setState(() {
                  showFav = !showFav;
                });
              },
              child: Text(showFav ? "Starred" : "All"),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // void _makePhoneCall(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print('Could not launch $url');
  //   }
  // }
}
