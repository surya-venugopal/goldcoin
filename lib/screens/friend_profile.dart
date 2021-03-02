import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/main.dart';
import 'package:stocklot/providers/user.dart';

class FriendProfile extends StatefulWidget {
  static const routeName = "/friend-profile";

  @override
  _FriendProfileState createState() => _FriendProfileState();
}

class _FriendProfileState extends State<FriendProfile> {
  var friendId;
  DocumentSnapshot doc;
  var myRating = 3.0;
  var _isInit = true;
  var isVerified;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      friendId = ModalRoute.of(context).settings.arguments as String;
      doc = await FirebaseFirestore.instance
          .collection("User")
          .doc(friendId)
          .get();
      isVerified = doc.data()['isVerified'];
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: _isInit
          ? Container()
          : SafeArea(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(gradient: MyApp.getGradient()),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: size.width * 1 / 5,
                          horizontal: size.width * 1 / 20),
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  child: doc['dp'] == null || doc['dp'] == ""
                                      ? Text(
                                          doc['name'][0],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40),
                                        )
                                      : null,
                                  backgroundImage:
                                      doc['dp'] == null || doc['dp'] == ""
                                          ? null
                                          : NetworkImage(doc['dp']),
                                ),
                                if (isVerified != null && isVerified == true)
                                  Icon(Icons.verified,color: Theme.of(context).primaryColor,),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1 /
                                                2,
                                            child: Text("Person name")),
                                        Text(
                                          doc['name'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Icon(Icons.star),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Rating"),
                                        Text(
                                          "${doc['rating']} / 10",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Icon(Icons.mail),
                                    SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Email"),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1 /
                                              2,
                                          child: SelectableText(
                                            doc['mailId'],
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  initialValue: doc['description'],
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.description,
                                        color: Colors.black,
                                      ),
                                      labelText: "Description"),
                                ),
                                Divider(),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton(
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Rating"),
                                              content: RatingBar.builder(
                                                initialRating: 3,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 10,
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  myRating = rating;
                                                },
                                              ),
                                              actions: [
                                                FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Cancel"),
                                                  textColor: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                FlatButton(
                                                    textColor: Theme.of(context)
                                                        .primaryColor,
                                                    onPressed: () async {
                                                      var myId =
                                                          Provider.of<Users>(
                                                                  context,
                                                                  listen: false)
                                                              .getUser
                                                              .phone;
                                                      var db = FirebaseFirestore
                                                          .instance;
                                                      db.runTransaction(
                                                          (transaction) async {
                                                        var docRef = db
                                                            .collection("User")
                                                            .doc(friendId)
                                                            .collection(
                                                                "ratings")
                                                            .doc(myId);
                                                        // .doc(widget.friendId).collection("ratings").doc("+917010450504");
                                                        var docSnap =
                                                            await transaction
                                                                .get(docRef);
                                                        if (!docSnap.exists) {
                                                          var doc = await transaction
                                                              .get(db
                                                                  .collection(
                                                                      "User")
                                                                  .doc(
                                                                      friendId));
                                                          var newRating =
                                                              ((myRating +
                                                                      doc['rating']) ~/
                                                                  2);
                                                          transaction.update(
                                                              db
                                                                  .collection(
                                                                      "User")
                                                                  .doc(
                                                                      friendId),
                                                              {
                                                                "rating":
                                                                    newRating
                                                              });
                                                          transaction.set(
                                                              db
                                                                  .collection(
                                                                      "User")
                                                                  .doc(friendId)
                                                                  .collection(
                                                                      "ratings")
                                                                  .doc(myId),
                                                              {"id": myId});
                                                          Navigator.of(context)
                                                              .pop();
                                                          return newRating;
                                                        } else {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "You have already rated this person",
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                            textColor:
                                                                Colors.white,
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      });
                                                    },
                                                    child: Text("Confirm"))
                                              ],
                                            );
                                          });
                                    },
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: Text("Rate this person"),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
