import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/providers/chats.dart';
import 'package:stocklot/providers/make_call.dart';
import 'package:stocklot/providers/message.dart';
import 'package:stocklot/providers/permissions.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/widgets/chat_container.dart';
import '../widgets/record_widgets/record_button.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'friend_profile.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Set<int> users = {};

  bool isInit = true;
  ScrollController scrollController = ScrollController(keepScrollOffset: true);
  var db = FirebaseFirestore.instance;
  var person;

  // void _startCall(
  //   int callType,
  //   Set<int> opponents,
  //   String personId,
  //   String personName,
  //   String personDp,
  // ) {
  //   if (opponents.isEmpty) return;
  //
  //   P2PSession callSession =
  //       Environment.callClient.createCallSession(callType, opponents);
  //   Environment.currentCall = callSession;
  //   db.collection("User").doc(person['id']).update({
  //     "whoCalled": Provider.of<Users>(context, listen: false).getUser.phone
  //   }).then((value) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) =>
  //             CallScreen(callSession, false, personId, personName, personDp),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    person = ModalRoute.of(context).settings.arguments as Map;
    final personId = person['id'];
    final personName = person['name'];
    final dp = person['dp'];
    // final userVideoId = person['userVideoId'];
    // users.add(userVideoId);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ListTile(
          onTap: () {
            if (personId != "+918925461515" || personName != "Admin") {
              Navigator.of(context)
                  .pushNamed(FriendProfile.routeName, arguments: personId);
            }
          },
          title: Row(
            children: [
              dp == null || dp == ""
                    ? CircleAvatar(
                        child: Text(personName[0]),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(dp),
                      ),
              SizedBox(width: 15),
              Text(
                personName,
                style: TextStyle(color: Colors.white),
                // style: TextStyle(color: Colors.),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.videocam_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      content: Container(
                        height: 150,
                        child: Column(
                          children: [
                            Text(
                              "Stay calm, stay classy. Your video chat could be recorded for quality purposes.",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                            Text(
                              "\nNote : The person should open Goldcoin inorder to initiate a video call.",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () async{
                            sendMessage(
                                Provider.of<Users>(context, listen: false)
                                    .getUser
                                    .phone,
                                Provider.of<Users>(context, listen: false)
                                    .getUser
                                    .name,
                                personId,
                                "(VIDEO CALL INITIATED)",
                                context);
                            await db
                                .collection("User")
                                .doc(person['id'])
                                .update({
                              "whoCalled":
                                  Provider.of<Users>(context, listen: false)
                                      .getUser
                                      .phone
                            });
                            if (await Permissions
                                .cameraAndMicrophonePermissionsGranted()) {
                              CallUtils.dial(
                                from: UserModel(
                                    phone: Provider.of<Users>(context,
                                            listen: false)
                                        .getUser
                                        .phone,
                                    name: Provider.of<Users>(context,
                                            listen: false)
                                        .getUser
                                        .name,
                                    dp: Provider.of<Users>(context,
                                            listen: false)
                                        .getUser
                                        .dp),
                                to: UserModel(
                                    phone: personId, name: personName, dp: dp),
                                context: context,
                              );
                            }
                          },
                          child: Text("Start call"),
                          textColor: Theme.of(context).primaryColor,
                        )
                      ],
                    );
                  });

              // _startCall(CallType.VIDEO_CALL, users, personId, personName, dp);
            },
          ),
          // if (personId != "+918925461515" || personName != "Admin")
          //   IconButton(
          //     icon: Icon(
          //       Icons.person,
          //       color: Colors.white,
          //     ),
          //     onPressed: () {
          //       Navigator.of(context)
          //           .pushNamed(FriendProfile.routeName, arguments: personId);
          //     },
          //   ),
        ],
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          child: Container(
            color: Colors.white,
            child: MessagesPage(personId, scrollController, dp),
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage(String myId, String myName, String friendId,
      String text, BuildContext context) async {
    var db = FirebaseFirestore.instance;
    String fcmToken;
    var dp = Provider.of<Users>(context, listen: false).getUser.dp;
    await db.collection("User").doc(friendId).get().then((value) {
      fcmToken = value.data()['fcmToken'];
    });
    var data = MessageModel(
            message: text,
            res: "",
            personId: myId,
            fcmToken: fcmToken,
            time: DateTime.now(),
            type: 0)
        .getMap;
    Map<String, dynamic> frndData = {
      "personId": myId,
      "personName": myName,
      "personDp": dp,
      "isNew": false,
      "time": DateTime.now(),
    };
    try {
      await db
          .collection("User")
          .doc(friendId)
          .collection("friends")
          .doc(myId)
          .update(frndData);
    } catch (e) {
      frndData['isStarred'] = false;
      await db
          .collection("User")
          .doc(friendId)
          .collection("friends")
          .doc(myId)
          .set(frndData);
    }

    await db
        .collection("Message")
        .doc(Chats.getMessageId(myId, friendId))
        .collection("messages")
        .add(data);
  }
}

// ignore: must_be_immutable
class MessagesPage extends StatelessWidget {
  final personId;
  final String dp;
  bool isSending = false;
  bool isInit = true;
  final ScrollController scrollController;

  MessagesPage(this.personId, this.scrollController, this.dp);

  Widget build(BuildContext context) {
    String message = "";

    TextEditingController inputMessage = TextEditingController();
    inputMessage.addListener(() {
      message = inputMessage.text;
    });
    CollectionReference messageSnapshot = FirebaseFirestore.instance
        .collection('Message')
        .doc(Chats.getMessageId(
            Provider.of<Users>(context, listen: false).getUser.phone, personId))
        .collection('messages');
    var size = MediaQuery.of(context).size;

    Future.delayed(Duration(milliseconds: 500)).then((value) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent + 500,
          duration: Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn);
    });

    Future.delayed(Duration(seconds: 2)).then((value) {
      final snackBar = SnackBar(
        content: Text('Business purposes only.'),
        duration: Duration(milliseconds: 800),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });

    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: messageSnapshot.orderBy("time").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data.docs;
              return ListView.builder(
                controller: scrollController,
                itemCount: messages.length,
                itemBuilder: (ctx, index) => messages[index]['type'] == 0
                    ? messages[index]['personId'] ==
                            Provider.of<Users>(context, listen: false)
                                .getUser
                                .phone
                        ? Container(
                            alignment: Alignment.bottomRight,
                            child: MessageContainer(
                                messages[index]['message'],
                                messages[index]['time'],
                                "right",
                                messages[index]['type'],
                                index,
                                messages,
                                scrollController),
                          )
                        : Container(
                            alignment: Alignment.bottomLeft,
                            child: MessageContainer(
                                messages[index]['message'],
                                messages[index]['time'],
                                "left",
                                messages[index]['type'],
                                index,
                                messages,
                                scrollController),
                          )
                    : messages[index]['type'] == 1
                        ? messages[index]['personId'] ==
                                Provider.of<Users>(context, listen: false)
                                    .getUser
                                    .phone
                            ? Container(
                                alignment: Alignment.bottomRight,
                                child: MessageContainer(
                                    messages[index]['res'],
                                    messages[index]['time'],
                                    "right",
                                    messages[index]['type'],
                                    index,
                                    messages,
                                    scrollController),
                              )
                            : Container(
                                alignment: Alignment.bottomLeft,
                                child: MessageContainer(
                                    messages[index]['res'],
                                    messages[index]['time'],
                                    "left",
                                    messages[index]['type'],
                                    index,
                                    messages,
                                    scrollController),
                              )
                        : Container(
                            color: Colors.green,
                            height: 10,
                            width: 30,
                          ),
              );
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.all(5),
          width: size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RecordButton(
                    size: size,
                    personId: personId,
                    scrollController: scrollController),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  width: (size.width * 4 / 6) + 30,
                  child: TextFormField(
                    style: TextStyle(height: 1),
                    controller: inputMessage,
                    maxLines: 4,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Enter your message.",
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () async {
                      if (message.trim().length > 0) if (!isSending) {
                        isSending = true;

                        await sendMessage(
                            Provider.of<Users>(context, listen: false)
                                .getUser
                                .phone,
                            Provider.of<Users>(context, listen: false)
                                .getUser
                                .name,
                            personId,
                            message,
                            context);

                        isSending = false;
                        inputMessage.text = "";
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      }
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> sendMessage(String myId, String myName, String friendId,
      String text, BuildContext context) async {
    var db = FirebaseFirestore.instance;
    String fcmToken;
    var dp = Provider.of<Users>(context, listen: false).getUser.dp;
    await db.collection("User").doc(friendId).get().then((value) {
      fcmToken = value.data()['fcmToken'];
    });
    var data = MessageModel(
            message: text,
            res: "",
            personId: myId,
            fcmToken: fcmToken,
            time: DateTime.now(),
            type: 0)
        .getMap;
    Map<String, dynamic> frndData = {
      "personId": myId,
      "personName": myName,
      "personDp": dp,
      "isNew": false,
      "time": DateTime.now(),
    };
    try {
      await db
          .collection("User")
          .doc(friendId)
          .collection("friends")
          .doc(myId)
          .update(frndData);
    } catch (e) {
      frndData['isStarred'] = false;
      await db
          .collection("User")
          .doc(friendId)
          .collection("friends")
          .doc(myId)
          .set(frndData);
    }

    await db
        .collection("Message")
        .doc(Chats.getMessageId(myId, friendId))
        .collection("messages")
        .add(data);
  }
}
