import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/main.dart';
import 'package:stocklot/providers/call.dart';
import 'package:stocklot/providers/pass_code.dart';
import 'package:stocklot/screens/call_screen/pickup_screen.dart';
import 'package:stocklot/screens/search_products.dart';
import 'package:stocklot/screens/product_screen.dart';
import 'package:stocklot/screens/pass_code.dart';
import 'package:stocklot/screens/profile_personal_info_init.dart';
import 'package:stocklot/widgets/main_screen_widgets.dart';
import '../providers/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'profile_personal_info.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MainScreen extends StatefulWidget {
  static const routeName = "/mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _isLoading = false;
  var _isInit = true;
  var versionCorrect = true;
  var whoCalled = "";
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isConnected = false;

  DateTime endTime;

  start() async {
    var doc = await db.collection("version").doc("version").get();
    if (doc.data()['version'] == "2.0.0") {
      setState(() {
        _isLoading = true;
      });
      if (await Provider.of<Users>(context, listen: false).getInfoFromDb) {
        if (!Provider.of<Users>(context, listen: false).getUser.isLoggedIn) {
          // CubeUser user1 = CubeUser(
          //     id: user.userVideoId, login: user.phone, password: user.phone);
          //
          // if (CubeSessionManager.instance.isActiveSessionValid()) {
          //   CubeChatConnection.instance.login(user1).then((user1) {
          //     Environment.initCustomMediaConfigs(MediaQuery.of(context).size);
          //     Environment.initCalls(context);
          //   });
          // } else {
          //   createSession(user1).then((session) {
          //     CubeChatConnection.instance.login(user1).then((value) {
          //       Environment.initCustomMediaConfigs(
          //           MediaQuery.of(context).size);
          //       Environment.initCalls(context);
          //     });
          //   });
          // }
          endTime = Provider.of<Users>(context, listen: false).getUser.endTime;
          print(endTime.toString());
          db
              .collection("User")
              .doc(Provider.of<Users>(context, listen: false).getUser.phone)
              .update({"whoCalled": ""});
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (ctx) => PassCode("Enter Pin", true)))
              .then((value) => validate(
                  Provider.of<PassCodeModel>(context, listen: false).pin));
        } else {
          Provider.of<Users>(context, listen: false).getUser.isLoggedIn = true;
          Provider.of<PassCodeModel>(context, listen: false).pin = "0";

          setState(() {
            versionCorrect = true;
            _isLoading = false;
          });
        }
      } else {
        Navigator.of(context)
            .pushReplacementNamed(ProfilePersonalInfoInit.routeName);
      }
    } else {
      setState(() {
        _isInit = false;
        _isLoading = false;
        versionCorrect = false;
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        isConnected = true;
        start();
      } else {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            isConnected = true;
            start();
          }
        } on SocketException catch (_) {
          isConnected = false;
          setState(() {
            _isInit = false;
          });
        }
      }
    });
    super.initState();
  }

  Future<void> validate(String pin) async {
    if (pin == Provider.of<Users>(context, listen: false).getUser.pin) {
      Provider.of<Users>(context, listen: false).getUser.isLoggedIn = true;
      Provider.of<PassCodeModel>(context, listen: false).pin = "0";

      Fluttertoast.showToast(
          msg: "This app is currently free. Paid version is coming soon.",
          gravity: ToastGravity.CENTER,
          backgroundColor: Theme.of(context).primaryColor,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);

      dbListener();
      setState(() {
        versionCorrect = true;
        _isLoading = false;
        _isInit = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: "Pin mis-match. Please retry", toastLength: Toast.LENGTH_SHORT);
      Navigator.of(context)
          .push(
              MaterialPageRoute(builder: (ctx) => PassCode("Enter Pin", true)))
          .then((value) =>
              validate(Provider.of<PassCodeModel>(context, listen: false).pin));
    }
  }

  dbListener() {
    db
        .collection("User")
        .doc(Provider.of<Users>(context, listen: false).getUser.phone)
        .snapshots()
        .listen((doc) {
      whoCalled = doc.data()['whoCalled'];
      if (whoCalled != null && whoCalled != "") {
        print(whoCalled);
        var myId = Provider.of<Users>(context, listen: false).getUser.phone;
        var roomId;
        if (int.parse(myId.substring(3)) < int.parse(whoCalled.substring(3))) {
          roomId = myId.substring(3) + whoCalled.substring(3);
        } else {
          roomId = whoCalled.substring(3) + myId.substring(3);
        }
        Future.delayed(Duration(seconds: 2)).then((value) {
          db
              .collection("Calls")
              .doc(roomId)
              .collection("Members")
              .doc(myId)
              .get()
              .then((doc) {
            if (doc.exists) {
              Call call = Call.fromMap(doc.data());
              if (!call.hasDialled) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => PickUpScreen(
                      call: call,
                    ),
                  ),
                );
              }
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = Provider.of<Users>(context, listen: false).getUser;
    var ribbonMap = {
      "Stocklot": "ST",
      "Catering": "CT",
      "Export Surplus": "ES",
      "Job Offers": "JO",
      "Job Work": "JW",
      "Lease / Rentals": "LR",
      "Loans / Finance": "LF",
      "Market": "MT",
      "Others": "OS",
      "Scrap/Waste": "SW",
      "Seconds": "SD",
      "Spares & Service": "SS",
      "Transport": "TT",
      "Unit": "UT"
    };
    return Scaffold(
      appBar: !versionCorrect || _isInit || !isConnected
          ? null
          : endTime.compareTo(DateTime.now()) < 0
              ? null
              : AppBar(
                  elevation: 0,
                  title: Text(
                    "GoldCoin",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    _isLoading || _isInit || !versionCorrect
                        ? Container()
                        : IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SearchProducts.routeName);
                            },
                          ),
                    _isLoading || _isInit || !versionCorrect
                        ? Container()
                        : GestureDetector(
                            onTap: () async{
                              var dp = await Navigator.of(context)
                                  .pushNamed(ProfilePersonalInfo.routeName);
                              setState(() {
                                user.dp = dp;
                              });
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: user.dp == null
                                  ? null
                                  : NetworkImage(user.dp),
                            ),
                          ),
                  ],
                ),
      body: _isLoading || _isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : !isConnected
              ? Container(
                  width: size.width,
                  height: size.height,
                  child: Image.asset(
                    "assets/images/ConnectionLost.png",
                    fit: BoxFit.cover,
                  ))
              : !versionCorrect
                  ? Center(
                      child: Text("Please update the app"),
                    )
                  : endTime.compareTo(DateTime.now()) < 0
                      ? Center(
                          child: Text(
                              "Your subscription validity has ended.\nPlease contact admin to gain access."),
                        )
                      : Container(
                          // color: Theme.of(context).primaryColor,
                          decoration:
                              BoxDecoration(gradient: MyApp.getGradient()),
                          child: ListView(
                            children: [
                              SizedBox(height: 10),
                              StreamBuilder(
                                stream: db
                                    .collection("Categories")
                                    .doc("categories")
                                    .snapshots(),
                                builder: (_,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Something went wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  var doc = snapshot.data.data();

                                  var keys = doc.keys.toList(growable: false)
                                    ..sort(
                                        (k1, k2) => doc[k1].compareTo(doc[k2]));

                                  // LinkedHashMap sortedMap =
                                  //     new LinkedHashMap.fromIterable(keys,
                                  //         key: (k) => k, value: (k) => doc[k]);

                                  return Container(
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          ...keys.map((key) {
                                            return Row(
                                              children: [
                                                SizedBox(width: 5),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            ProductScreen
                                                                .routeName,
                                                            arguments: key);
                                                  },
                                                  child: Container(
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          radius: 25,
                                                          child: Text(
                                                            ribbonMap[key],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          key,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    width: size.width / 5,
                                                    height: 90,
                                                    // color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 5)
                                              ],
                                            );
                                          })
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              MainScreenWidgets()
                            ],
                          ),
                        ),
      floatingActionButton: _isInit
          ? null
          : endTime.compareTo(DateTime.now()) > 0
              ? null
              : FloatingActionButton.extended(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            content: Container(
                              width: size.width / 2,
                              height: size.width / 2,
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: RichText(
                                  // "To advertise here, contact admin\n\nemail : abcd@gmail.com\nphone : 9486532551",
                                  text: TextSpan(
                                      text: "You can contact admin via",
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 16),
                                      children: [
                                        TextSpan(
                                            text: "\n\n\nEmail : ",
                                            children: [
                                              TextSpan(
                                                  text: "abcd@gmail.com",
                                                  style: TextStyle())
                                            ]),
                                        TextSpan(
                                            text: "\n\nPhone : ",
                                            children: [
                                              TextSpan(
                                                  text: "+91 9486532551",
                                                  style: TextStyle())
                                            ]),
                                      ]),
                                ),
                              ),
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  MyApp.makePhoneCall("tel:+919486532551");
                                },
                                textColor: Theme.of(context).primaryColor,
                                child: Text("Call"),
                              )
                            ],
                          );
                        });
                  },
                  label: Text("Admin"),
                  icon: Icon(Icons.admin_panel_settings),
                ),
    );
  }
}
