import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'message.dart';

class ChatsModel {
  final String personId;
  final String personName;
  final DateTime time;
  final String personDp;

  // final String productName;

  ChatsModel({this.personDp, this.personId, this.personName, this.time});
}

class Chats with ChangeNotifier {
  List<ChatsModel> _chats = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  void setChats(List<QueryDocumentSnapshot> chats) {
    _chats = chats
        .map((doc) => ChatsModel(
              personDp: doc.data()['personDp'],
              personId: doc['personId'],
              personName: doc['personName'],
              time: (doc['time'] as Timestamp).toDate(),
            ))
        .toList();
  }

  List<ChatsModel> get getChats {
    return [..._chats];
  }

  String getPersonName(String personId) {
    return _chats
        .firstWhere((element) => element.personId == personId)
        .personName;
  }

  Future<void> wantToTalk(
      String sellerId, String buyerId, BuildContext context,String topic) async {
    String fcmToken;

    await db.collection("User").doc(sellerId).get().then((value) {
      fcmToken = value.data()['fcmToken'];
    });

    Map<String, dynamic> data = {
      "personId": buyerId,
      "personName": Provider.of<Users>(context, listen: false).getUser.name,
      "time": DateTime.now(),
      "isNew":true,
      "isStarred": false
    };

    await db
        .collection("User")
        .doc(sellerId)
        .collection("friends")
        .doc(buyerId)
        .set(data)
        .then((value) async {
      MessageModel message = MessageModel(
          message: "($topic) ... I'm interested in your product!",
          res: "",
          personId: buyerId,
          type: 0,
          time: DateTime.now(),
          fcmToken: fcmToken);
      await db
          .collection("Message")
          .doc(getMessageId(sellerId, buyerId))
          .collection("messages")
          .add(message.getMap)
          .then((value) {});
    });
  }

  static String getMessageId(String sellerId, String buyerId) {
    if (sellerId.compareTo(buyerId) > 0) {
      return buyerId + "_" + sellerId;
    } else {
      return sellerId + "_" + buyerId;
    }
  }
}
