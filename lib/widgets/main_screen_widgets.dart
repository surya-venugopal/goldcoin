import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/providers/chats.dart';
import 'package:stocklot/providers/product.dart';
import 'package:stocklot/providers/wins.dart';
import 'package:stocklot/screens/all_users.dart';
import 'package:stocklot/screens/chat_screen.dart';
import 'package:stocklot/screens/main_screen/main_actions.dart';
import 'package:stocklot/screens/product_detail_screen.dart';
import 'package:stocklot/screens/requests_screen.dart';
import 'package:stocklot/screens/user_products_screen.dart';

import 'package:stocklot/screens/wish_list.dart';
import 'package:stocklot/widgets/chats_viewer.dart';
import 'package:stocklot/widgets/choose_category.dart';
import '../constant.dart';
import '../main.dart';
import '../providers/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';

import 'package:scratcher/scratcher.dart';

import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'package:url_launcher/url_launcher.dart';

class MainScreenWidgets extends StatefulWidget {
  @override
  _MainScreenWidgetsState createState() => _MainScreenWidgetsState();
}

class _MainScreenWidgetsState extends State<MainScreenWidgets> {
  var topicController = TextEditingController();
  var descriptionController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {
    topicController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget contactAdmin(size, text) {
    return AlertDialog(
      content: Container(
        width: size.width / 2,
        height: size.width / 2,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: RichText(
            // "To advertise here, contact admin\n\nemail : abcd@gmail.com\nphone : 9486532551",
            text: TextSpan(
                text: text,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  TextSpan(text: "\n\nEmail : ", children: [
                    TextSpan(text: "abcd@gmail.com", style: TextStyle())
                  ]),
                  TextSpan(text: "\nPhone : ", children: [
                    TextSpan(text: "+91 9486532551", style: TextStyle())
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
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = Provider.of<Users>(context, listen: false).getUser;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            // margin: EdgeInsets.only(top: size.height / 4),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  // height: size.height*5/4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      MainActions(),
                      Divider(
                        thickness: 1,
                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context)
                      //               .pushNamed(ChatViewer.routeName);
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Ad(1),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: StreamBuilder(
                          stream: db
                              .collection("User")
                              .doc(user.phone)
                              .collection("friends")
                              .orderBy("time", descending: true)
                              .where("isNew", isEqualTo: true)
                              .limit(10)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: size.width * 0.13,
                                  height: size.height / 5.5,
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(ChatViewer.routeName);
                                      },
                                      child: Text(
                                        "Notices",
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  width: size.width * 0.87 - 20,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var doc = await db
                                              .collection("User")
                                              .doc("+918925461515")
                                              .get();

                                          return Navigator.of(context)
                                              .pushNamed(ChatScreen.routeName,
                                                  arguments: {
                                                "id": doc.id,
                                                "name": "Admin",
                                                "dp": "",
                                              });
                                        },
                                        child: Container(
                                          width: size.width / 4,
                                          margin: EdgeInsets.only(right: 5),
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.grey[300],
                                          ),
                                          child: GridTile(
                                              child: Icon(Icons.person),
                                              footer: Container(
                                                color: Colors.grey[300],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Admin",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                      ...snapshot.data.docs
                                          .map((docu) => GestureDetector(
                                                onTap: () async {
                                                  var doc = await db
                                                      .collection("User")
                                                      .doc(docu
                                                          .data()['personId'])
                                                      .get();

                                                  return Navigator.of(context)
                                                      .pushNamed(
                                                          ChatScreen.routeName,
                                                          arguments: {
                                                        "id": docu
                                                            .data()['personId'],
                                                        "name": docu.data()[
                                                            'personName'],
                                                        "dp": doc.data()['dp'],
                                                      });
                                                },
                                                child: Container(
                                                  width: size.width / 4,
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.grey[300],
                                                  ),
                                                  child: GridTile(
                                                      child: docu.data()[
                                                                      'personDp'] ==
                                                                  null ||
                                                              docu.data()[
                                                                      'personDp'] ==
                                                                  ""
                                                          ? Icon(Icons.person)
                                                          // : Icon(Icons
                                                          //     .person),
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: docu
                                                                        .data()[
                                                                    'personDp'],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                      footer: Container(
                                                        color: Colors.grey[300],
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              MyApp.capitalize(docu
                                                                          .data()[
                                                                              'personName']
                                                                          .toString()
                                                                          .length <
                                                                      6
                                                                  ? docu.data()[
                                                                      'personName']
                                                                  : docu
                                                                      .data()[
                                                                          'personName']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          6)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Icon(
                                                              docu.data()[
                                                                      'isStarred']
                                                                  ? Icons.star
                                                                  : Icons
                                                                      .star_border,
                                                              color:
                                                                  Colors.amber,
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context)
                      //               .pushNamed(ChatViewer.routeName);
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: StreamBuilder(
                          stream: db
                              .collection("User")
                              .doc(user.phone)
                              .collection("friends")
                              .orderBy("time", descending: true)
                              .where("isNew", isEqualTo: false)
                              .limit(10)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: size.width * 0.13,
                                  height: size.height / 5.5,
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(ChatViewer.routeName);
                                      },
                                      child: Text(
                                        "Chats",
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  width: size.width * 0.87 - 20,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var doc = await db
                                              .collection("User")
                                              .doc("+918925461515")
                                              .get();

                                          return Navigator.of(context)
                                              .pushNamed(ChatScreen.routeName,
                                                  arguments: {
                                                "id": doc.id,
                                                "name": "Admin",
                                                "dp": "",
                                              });
                                        },
                                        child: Container(
                                          width: size.width / 4,
                                          margin: EdgeInsets.only(right: 5),
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.grey[300],
                                          ),
                                          child: GridTile(
                                              child: Icon(Icons.person),
                                              footer: Container(
                                                color: Colors.grey[300],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Admin",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    )
                                                  ],
                                                ),
                                              )),
                                        ),
                                      ),
                                      ...snapshot.data.docs
                                          .map((docu) => GestureDetector(
                                                onTap: () async {
                                                  var doc = await db
                                                      .collection("User")
                                                      .doc(docu
                                                          .data()['personId'])
                                                      .get();

                                                  return Navigator.of(context)
                                                      .pushNamed(
                                                          ChatScreen.routeName,
                                                          arguments: {
                                                        "id": docu
                                                            .data()['personId'],
                                                        "name": docu.data()[
                                                            'personName'],
                                                        "dp": doc.data()['dp'],
                                                      });
                                                },
                                                child: Container(
                                                  width: size.width / 4,
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.grey[300],
                                                  ),
                                                  child: GridTile(
                                                      child: docu.data()[
                                                                      'personDp'] ==
                                                                  null ||
                                                              docu.data()[
                                                                      'personDp'] ==
                                                                  ""
                                                          ? Icon(Icons.person)
                                                          // : Icon(Icons
                                                          //     .person),
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: docu
                                                                        .data()[
                                                                    'personDp'],
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                      footer: Container(
                                                        color: Colors.grey[300],
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Text(
                                                              MyApp.capitalize(docu
                                                                          .data()[
                                                                              'personName']
                                                                          .toString()
                                                                          .length <
                                                                      6
                                                                  ? docu.data()[
                                                                      'personName']
                                                                  : docu
                                                                      .data()[
                                                                          'personName']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          6)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Icon(
                                                              docu.data()[
                                                                      'isStarred']
                                                                  ? Icons.star
                                                                  : Icons
                                                                      .star_border,
                                                              color:
                                                                  Colors.amber,
                                                            )
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context)
                      //               .pushNamed(RequestScreen.routeName);
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),

                      Ad(2),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: StreamBuilder(
                          stream: db
                              .collection("Request")
                              .orderBy("time", descending: true)
                              .limit(10)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: size.width * 0.13,
                                  height: size.height / 5.5,
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(RequestScreen.routeName);
                                      },
                                      child: Text(
                                        "Wanted",
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  width: size.width * 0.87 - 20,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...snapshot.data.docs
                                          .map((docu) => GestureDetector(
                                                onTap: () async {
                                                  // var doc = db
                                                  //     .collection(
                                                  //         "User")
                                                  //     .doc(docu
                                                  //         .data()['personId'])
                                                  //     .get();
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        return AlertDialog(
                                                          title: Text(MyApp
                                                              .capitalize(docu
                                                                      .data()[
                                                                  'topic'])),
                                                          content: Text(
                                                            MyApp.capitalize(docu
                                                                .data()[
                                                                    'description']
                                                                .toString()),
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          ),
                                                          actions: [
                                                            docu.data()['personId'] ==
                                                                    user.phone
                                                                ? Container()
                                                                : FlatButton(
                                                                    child: Text(
                                                                      "I'm interested",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "Notification sent successfully!");
                                                                      await Provider.of<Chats>(context, listen: false).wantToTalk(
                                                                          docu.data()[
                                                                              'personId'],
                                                                          Provider.of<Users>(context, listen: false)
                                                                              .getUser
                                                                              .phone,
                                                                          context,
                                                                          docu.data()[
                                                                              'topic']);
                                                                    },
                                                                  )
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Container(
                                                  width: size.width / 4,
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                    color: Colors.grey[300],
                                                  ),
                                                  child: GridTile(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20),
                                                        child: Text(MyApp
                                                            .capitalize(docu
                                                                .data()[
                                                                    'description']
                                                                .toString())),
                                                      ),
                                                      header: Text(
                                                          MyApp.capitalize(docu
                                                                      .data()[
                                                                          'personName']
                                                                      .toString()
                                                                      .length <
                                                                  6
                                                              ? docu.data()[
                                                                  'personName']
                                                              : docu
                                                                  .data()[
                                                                      'personName']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 6)),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      footer: Container(
                                                        color: Colors.grey[300],
                                                        child: Text(
                                                          MyApp.capitalize(docu
                                                                      .data()[
                                                                          'topic']
                                                                      .toString()
                                                                      .length <
                                                                  6
                                                              ? docu.data()[
                                                                  'topic']
                                                              : docu
                                                                  .data()[
                                                                      'topic']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 6)),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )),
                                                ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context)
                      //               .pushNamed(UserProductsScreen.routeName);
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        child: StreamBuilder(
                            stream: db
                                .collection("Product")
                                .where("person_id",
                                    isEqualTo: Provider.of<Users>(context,
                                            listen: false)
                                        .getUser
                                        .phone)
                                .orderBy("time", descending: true)
                                .limit(10)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              var products = snapshot.data.docs;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    width: size.width * 0.13,
                                    height: size.height / 5.5,
                                    alignment: Alignment.center,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              UserProductsScreen.routeName);
                                        },
                                        child: Text(
                                          "Posts",
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 10),
                                    width: size.width * 0.87 - 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      //padding: const EdgeInsets.all(10.0),
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        var product = Product(
                                          time: (products[index].data()['time']
                                                  as Timestamp)
                                              .toDate(),
                                          videoUrl: products[index]
                                              .data()['videoUrl'],
                                          personId: products[index]
                                              .data()['person_id'],
                                          quantity: products[index]
                                              .data()['quantity'],
                                          id: products[index].id,
                                          personName: products[index]
                                              .data()['personName'],
                                          title:
                                              products[index].data()['title'],
                                          description: products[index]
                                              .data()['description'],
                                          price:
                                              products[index].data()['price'],
                                          imageUrl: List<String>.from(
                                              products[index]
                                                  .data()['imageUrl']),
                                          isAd: products[index].data()['isAd'],
                                          isOffer:
                                              products[index].data()['isOffer'],
                                          category: products[index]
                                              .data()['category']
                                              .toString(),
                                        );
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                ProductDetailScreen.routeName,
                                                arguments: product
                                                // {
                                                //   'id': product.id,
                                                //   'index': index,
                                                //   'isFav': isFavorite,
                                                // }
                                                );
                                          },
                                          child: Container(
                                            width: size.width / 4,
                                            margin: EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: GridTile(
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10)),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        product.imageUrl[0],
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              footer: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                                child: Container(
                                                  color: Colors.grey[300],
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical:
                                                          kDefaultPaddin / 4),
                                                  child: Text(
                                                    MyApp.capitalize(
                                                        product.title),
                                                    textAlign: TextAlign.center,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context)
                      //               .pushNamed(WishList.routeName);
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        child: StreamBuilder(
                            stream: db
                                .collection("Product")
                                .orderBy("time", descending: true)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              var products = snapshot.data.docs;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    width: size.width * 0.13,
                                    height: size.height / 5.5,
                                    alignment: Alignment.center,
                                    child: RotatedBox(
                                      quarterTurns: 3,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed(WishList.routeName);
                                        },
                                        child: Text(
                                          "Saved",
                                          style: TextStyle(
                                            letterSpacing: 1,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 10),
                                    width: size.width * 0.87 - 20,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      //padding: const EdgeInsets.all(10.0),
                                      itemCount: products.length,
                                      itemBuilder: (context, index) {
                                        var product = Product(
                                          time: (products[index].data()['time']
                                                  as Timestamp)
                                              .toDate(),
                                          videoUrl: products[index]
                                              .data()['videoUrl'],
                                          personId: products[index]
                                              .data()['person_id'],
                                          quantity: products[index]
                                              .data()['quantity'],
                                          id: products[index].id,
                                          personName: products[index]
                                              .data()['personName'],
                                          title:
                                              products[index].data()['title'],
                                          description: products[index]
                                              .data()['description'],
                                          price:
                                              products[index].data()['price'],
                                          imageUrl: List<String>.from(
                                              products[index]
                                                  .data()['imageUrl']),
                                          isAd: products[index].data()['isAd'],
                                          isOffer:
                                              products[index].data()['isOffer'],
                                          category: products[index]
                                              .data()['category']
                                              .toString(),
                                        );

                                        return StreamBuilder(
                                            stream: db
                                                .collection("Product")
                                                .doc(snapshot
                                                    .data.docs[index].id)
                                                .collection("favorites")
                                                .doc(user.phone)
                                                .snapshots(),
                                            builder: (_,
                                                AsyncSnapshot<DocumentSnapshot>
                                                    snapshot1) {
                                              if (snapshot1.hasError) {
                                                return Text(
                                                    'Something went wrong');
                                              }
                                              if (snapshot1.connectionState ==
                                                  ConnectionState.waiting) {
                                                // return Center(
                                                //     child: CircularProgressIndicator());
                                                return Container();
                                              }
                                              if (snapshot1.data.exists) {
                                                product.isFavorite = true;
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(
                                                        ProductDetailScreen
                                                            .routeName,
                                                        arguments: product
                                                        // {
                                                        //   'id': product.id,
                                                        //   'index': index,
                                                        //   'isFav': isFavorite,
                                                        // }
                                                        );
                                                  },
                                                  child: Container(
                                                    width: size.width / 4,
                                                    margin: EdgeInsets.only(
                                                        right: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: GridTile(
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: product
                                                                .imageUrl[0],
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      footer: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        child: Container(
                                                          color:
                                                              Colors.grey[300],
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              vertical:
                                                                  kDefaultPaddin /
                                                                      4),
                                                          child: Text(
                                                            MyApp.capitalize(
                                                                product.title),
                                                            textAlign: TextAlign
                                                                .center,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                product.isFavorite = false;
                                                return Container();
                                              }

                                              // return ProductItem(
                                              //     product);
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Ad(3),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Fluttertoast.showToast(
                      //             msg: "Coming soon!",
                      //             backgroundColor:
                      //                 Theme.of(context).primaryColor,
                      //             textColor: Colors.white,
                      //           );
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              width: size.width * 0.13,
                              height: size.height / 5.5,
                              alignment: Alignment.center,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: FlatButton(
                                  onPressed: () {
                                    // Fluttertoast.showToast(
                                    //   msg: "Coming soon!",
                                    //   backgroundColor:
                                    //       Theme.of(context).primaryColor,
                                    //   textColor: Colors.white,
                                    // );
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return contactAdmin(size,
                                              "To add a Store, contact admin");
                                        });
                                  },
                                  child: Text(
                                    "Stores",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              width: size.width * 0.87 - 20,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return contactAdmin(size,
                                                "To add a store, contact admin");
                                          });
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.store),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Store 1",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return contactAdmin(size,
                                                "To add a Store, contact admin");
                                          });
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.store),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Store 2",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return contactAdmin(size,
                                                "To add a Store, contact admin");
                                          });
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.store),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Store 3",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              width: size.width * 0.13,
                              height: size.height / 5.5,
                              alignment: Alignment.center,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: FlatButton(
                                  onPressed: () {
                                    Fluttertoast.showToast(
                                      msg: "Coming soon!",
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      textColor: Colors.white,
                                    );
                                  },
                                  child: Text(
                                    "Showcase",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              width: size.width * 0.87 - 20,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                        msg: "Coming soon!",
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                      );
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.card_giftcard),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Showcase 1",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                        msg: "Coming soon!",
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                      );
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.card_giftcard),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Showcase 2",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Fluttertoast.showToast(
                                        msg: "Coming soon!",
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor: Colors.white,
                                      );
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.card_giftcard),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Showcase 3",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Ad(4),
                      SizedBox(
                        height: 20,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Center(
                      //       child: FlatButton(
                      //         shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(10)),
                      //         child: Text(
                      //           "More",
                      //           style: TextStyle(fontSize: 14),
                      //         ),
                      //         onPressed: () {
                      //           Navigator.of(context)
                      //               .pushNamed(AllUsers.routeName);
                      //         },
                      //         color: Theme.of(context).primaryColor,
                      //         textColor: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: StreamBuilder(
                          stream: db
                              .collection("User")
                              .orderBy("name")
                              .limit(10)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: size.width * 0.13,
                                  height: size.height / 5.5,
                                  alignment: Alignment.center,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(AllUsers.routeName);
                                      },
                                      child: Text(
                                        "Users",
                                        style: TextStyle(
                                          letterSpacing: 1,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10, bottom: 10, left: 10),
                                  width: size.width * 0.87 - 20,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      ...snapshot.data.docs
                                          .map((docu) => GestureDetector(
                                                onTap: () async {
                                                  return Navigator.of(context)
                                                      .pushNamed(
                                                          ChatScreen.routeName,
                                                          arguments: {
                                                        "id": docu.id,
                                                        "name":
                                                            docu.data()['name'],
                                                        "dp": docu.data()['dp'],
                                                      });
                                                },
                                                child: docu.id == user.phone
                                                    ? Container()
                                                    : Container(
                                                        width: size.width / 4,
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color:
                                                              Colors.grey[300],
                                                        ),
                                                        child: GridTile(
                                                            child: docu.data()[
                                                                            'dp'] ==
                                                                        null ||
                                                                    docu.data()[
                                                                            'dp'] ==
                                                                        ""
                                                                ? Icon(Icons
                                                                    .person)
                                                                // : Icon(Icons
                                                                //     .person),
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          docu.data()[
                                                                              'dp'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                            footer: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                color: Colors
                                                                    .grey[300],
                                                                child: Text(
                                                                  MyApp.capitalize(docu.data()['name'].toString().length <
                                                                          6
                                                                      ? docu.data()[
                                                                          'name']
                                                                      : docu
                                                                          .data()[
                                                                              'name']
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              6)),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ))),
                                                      ),
                                              ))
                                          .toList(),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 0.1,
                              color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        height: size.height / 5.5,
                        width: size.width,
                        // color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              width: size.width * 0.13,
                              height: size.height / 5.5,
                              alignment: Alignment.center,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: FlatButton(
                                  onPressed: () {
                                    // Fluttertoast.showToast(
                                    //   msg: "Coming soon!",
                                    //   backgroundColor:
                                    //       Theme.of(context).primaryColor,
                                    //   textColor: Colors.white,
                                    // );
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return contactAdmin(size,
                                              "To add a Group, contact admin");
                                        });
                                  },
                                  child: Text(
                                    "Groups",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 10),
                              width: size.width * 0.87 - 20,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return contactAdmin(size,
                                                "To add a Group, contact admin");
                                          });
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.people_rounded),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Group 1",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return contactAdmin(size,
                                                "To add a Group, contact admin");
                                          });
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.people_rounded),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Group 2",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return contactAdmin(size,
                                                "To add a Group, contact admin");
                                          });
                                    },
                                    child: Container(
                                      width: size.width / 4,
                                      margin: EdgeInsets.only(right: 5),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey[300],
                                      ),
                                      child: GridTile(
                                          child: Icon(Icons.people_rounded),
                                          footer: Container(
                                              alignment: Alignment.center,
                                              color: Colors.grey[300],
                                              child: Text(
                                                "Group 3",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(),
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Ad(5),
                      SizedBox(
                        height: 20,
                      ),
                      // Divider(
                      //   thickness: 1,
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).pushNamed(AllUsers.routeName);
                      //   },
                      //   child: Container(
                      //     width: 100,
                      //     height: 100,
                      //     decoration: BoxDecoration(
                      //         gradient: MyApp.getGradient(),
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(20))),
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       "Show\nAll\nUser",
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(fontSize: 20, color: Colors.white),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Ad extends StatefulWidget {
  final num;

  const Ad(this.num);

  @override
  _AdState createState() => _AdState();
}

class _AdState extends State<Ad> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  VideoPlayerController _controller;
  DocumentSnapshot doc;
  var audioOn = true;

  Widget contactAdmin(size, text) {
    return AlertDialog(
      content: Container(
        width: size.width / 2,
        height: size.width / 2,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: RichText(
            // "To advertise here, contact admin\n\nemail : abcd@gmail.com\nphone : 9486532551",
            text: TextSpan(
                text: text,
                style: TextStyle(color: Colors.black87, fontSize: 16),
                children: [
                  TextSpan(text: "\n\nEmail : ", children: [
                    TextSpan(text: "abcd@gmail.com", style: TextStyle())
                  ]),
                  TextSpan(text: "\nPhone : ", children: [
                    TextSpan(text: "+91 9486532551", style: TextStyle())
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
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () async {
      doc = await db.collection("Ads").doc("main${widget.num}").get();
      if (doc.data()['type'] == 1) {
        _controller = VideoPlayerController.network(doc.data()['uri'])
          ..initialize().then((_) {
            setState(() {});
          });
        _controller.setVolume(5);
        _controller.setLooping(true);
        _controller.play();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: Container(
        width: size.width,
        height: 200,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(width: 1, color: Theme.of(context).accentColor)),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: 200,
              child: doc == null
                  ? Text("Ads will appear here")
                  : GestureDetector(
                      onTap: () async {
                        var url = doc.data()['link'].toString();
                        if (await canLaunch(url))
                          await launch(url);
                        else
                          // can't launch url, there is some error
                          throw "Could not launch $url";
                      },
                      child: doc.data()['type'] == 1
                          ? _controller.value.initialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : Container()
                          : Image.network(
                              doc.data()['uri'],
                              fit: BoxFit.cover,
                              width: size.width,
                            ),
                    ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return contactAdmin(
                            size, "To advertise here, contact admin.");
                      });
                },
                icon: Icon(
                  Icons.info,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (doc != null && doc.data()['type'] == 1)
              Positioned(
                left: 0,
                top: 0,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    if (!audioOn) {
                      _controller.setVolume(5);
                      audioOn = true;
                    } else {
                      _controller.setVolume(0);
                      audioOn = false;
                    }
                  },
                  child: Icon(
                    Icons.audiotrack,
                  ),
                ),
              ),
          ],
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
