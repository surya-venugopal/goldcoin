import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserModel {
  String mailId;
  String name;
  String phone;
  DateTime dob;
  String address;
  String fcmToken;
  String pin;
  String description;
  int individualOrCompany;
  int rating;
  String dp;
  bool isLoggedIn;
  int userVideoId;
  bool isVerified;
  DateTime endTime;

  UserModel(
      {this.isVerified,
      this.phone,
      this.dob,
      this.mailId,
      this.name,
      this.address,
      this.isLoggedIn,
      this.fcmToken,
      this.individualOrCompany,
      this.description,
      this.rating,
      this.dp,
      this.pin,
      this.userVideoId,
      this.endTime});
}

class Users with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;

  UserModel _userModel = UserModel(
    name: "",
    mailId: "",
    phone: "",
    dob: null,
    rating: 10,
    individualOrCompany: null,
    description: "",
    address: "",
    dp: "",
    isLoggedIn: false,
    pin: "0",
    userVideoId: 0,
    isVerified: false,
    endTime: null,
  );

  void set(String phone) {
    _userModel = UserModel(
        mailId: "",
        name: "",
        dp: "",
        phone: phone,
        dob: null,
        individualOrCompany: null,
        description: "",
        address: "",
        rating: 10,
        pin: "0",
        isLoggedIn: false,
        isVerified: false,
        endTime: null,
        userVideoId: 0);
  }

  void update(
      {String name,
      DateTime dob,
      String address,
      bool isLoggedIn,
      String fcmToken,
      String pin,
      String mailId,
      int individualOrCompany,
      String description,
      int rating,
      String dp,
      bool isVerified,
      DateTime endTime,
      int userVideoId}) {
    _userModel.name = name;
    _userModel.dob = dob;
    _userModel.address = address;
    _userModel.isLoggedIn = isLoggedIn;
    _userModel.fcmToken = fcmToken;
    _userModel.pin = pin;
    _userModel.mailId = mailId;
    _userModel.description = description;
    _userModel.rating = rating;
    _userModel.dp = dp;
    _userModel.userVideoId = userVideoId;
    _userModel.isVerified = isVerified;
    _userModel.endTime = endTime;

    notifyListeners();
  }

  Map<String, Object> get getMap {
    return {
      'name': _userModel.name,
      'phone': _userModel.phone,
      'dob': _userModel.dob.toString(),
      'address': _userModel.address,
      'fcmToken': _userModel.fcmToken,
      'pin': _userModel.pin,
      'dp': _userModel.dp,
      'mailId': _userModel.mailId,
      'description': _userModel.description,
      'rating': _userModel.rating,
      'userVideoId': _userModel.userVideoId,
      'endTime':_userModel.endTime
    };
  }

  void updatePin(String pin) {
    _userModel.pin = pin;
    notifyListeners();
  }

  Future<void> updateDp(String dp) async {
    _userModel.dp = dp;
    notifyListeners();
    db.collection("User").doc(_userModel.phone).update({"dp": dp});
  }

  Future updateRating(int myRating) async {
    if (_userModel.rating != null) {
      _userModel.rating = (_userModel.rating + myRating) ~/ 2;
      await db
          .collection("User")
          .doc(_userModel.phone)
          .update({"rating": _userModel.rating});
    } else {
      await db
          .collection("User")
          .doc(_userModel.phone)
          .update({"rating": myRating});
    }
  }

  Future<void> updateInfoInDb() async {
    await db.collection("User").doc(_userModel.phone).set(getMap);
  }

  Future<bool> get getInfoFromDb async {
    var temp = false;

    var value = await db.collection("User").doc(_userModel.phone).get();
    if (value.exists) {
      temp = true;
      update(
        name: value.data()['name'],
        dob: DateTime.parse(value.data()['dob']),
        address: value.data()['address'],
        isLoggedIn: _userModel.isLoggedIn,
        fcmToken: value.data()['fcmToken'],
        pin: value.data()['pin'],
        dp: value.data()['dp'],
        mailId: value.data()['mailId'],
        rating: value.data()['rating'].toInt(),
        description: value.data()['description'],
        individualOrCompany: value.data()['individualOrCompany'],
        userVideoId: value.data()['userVideoId'],
        isVerified: value.data()['isVerified'],
        endTime: (value.data()['endTime'] as Timestamp).toDate()
      );
      FirebaseMessaging fbm = FirebaseMessaging.instance;
      String fcmToken;
      if (kIsWeb) {
        // fcmToken = await fbm.getToken(vapidKey: "BHdgq1CxatjRYWc0ptigq4RUAleadt4KpL4Bqflw-J84tTziLuF9Dq13p4yO14hn4opjf4Q2jvblFGnwT_D9Xtc");
      } else {
        fcmToken = await fbm.getToken();
        await db
            .collection("User")
            .doc(_userModel.phone)
            .update({"fcmToken": fcmToken});
      }
    }

    return temp;
  }

  UserModel get getUser {
    return _userModel;
  }
}
