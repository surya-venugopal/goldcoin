import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/providers/wins.dart';
import 'package:stocklot/widgets/choose_category.dart';
import '../../providers/user.dart';
import 'package:share/share.dart';
import 'package:scratcher/scratcher.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class MainActions extends StatefulWidget {
  @override
  _MainActionsState createState() => _MainActionsState();
}

class _MainActionsState extends State<MainActions> {
  var topicController = TextEditingController();
  var descriptionController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void dispose() {
    topicController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = Provider.of<Users>(context, listen: false).getUser;
    var isHighLighted = Provider.of<Wins>(context).isHighLighted;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return ChooseCategory();
                });
          },
          child: Container(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 25,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Add",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            width: size.width / 5,
            height: 80,
            // color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text("Wanted"),
                    content: Container(
                      width: size.width,
                      height: size.width,
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: topicController,
                            autovalidateMode: AutovalidateMode.always,
                            decoration: InputDecoration(labelText: "Topic"),
                            validator: (val) {
                              if (val.trim().length < 0)
                                return "Enter some topic";
                              return null;
                            },
                          ),
                          TextFormField(
                              controller: descriptionController,
                              autovalidateMode: AutovalidateMode.always,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              decoration:
                                  InputDecoration(labelText: "Description"),
                              validator: (val) {
                                if (val.trim().length < 0)
                                  return "Enter some description";
                                return null;
                              }),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          }),
                      TextButton(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          onPressed: () async {
                            showDialog(
                                context: ctx,
                                builder: (ctx2) => AlertDialog(
                                      title: Text("Disclaimers"),
                                      content: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Text(
                                              "* I confirm that there is no objectionable material in this post.",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "* All responsibility for this post rests with me.",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "* I agree that Goldcoin may defer / delete / report post if found non relevant or objectionable.",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(height: 20),
                                            Text(
                                              "*  I understand that any disagreeable activity by me can lead to me being banned from use of the Goldcoin platform.",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () async {
                                            Navigator.of(ctx2).pop();
                                            if (topicController.text
                                                    .trim()
                                                    .isNotEmpty &&
                                                descriptionController.text
                                                    .trim()
                                                    .isNotEmpty) {
                                              var map = {
                                                "personId": user.phone,
                                                "topic": topicController.text,
                                                "personName": user.name,
                                                "description":
                                                    descriptionController.text,
                                                "time": DateTime.now()
                                              };
                                              await db
                                                  .collection("Request")
                                                  .add(map);
                                              topicController.text = "";
                                              descriptionController.text = "";
                                              Navigator.of(ctx).pop();
                                            }
                                          },
                                          child: Text(
                                            "I agree",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        )
                                      ],
                                    ));
                          })
                    ],
                  );
                });
          },
          child: Container(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 25,
                  child: Icon(Icons.add, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Wanted",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            width: size.width / 5,
            height: 80,
            // color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Share.share("Download Goldcoin from playstore");
          },
          child: Container(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 25,
                  child: Icon(Icons.share, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Refer",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            width: size.width / 5,
            height: 80,
            // color: Colors.white,
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text("Wins", style: TextStyle(color: Colors.white)),
                    content: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        width: size.width,
                        height: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Text(
                            //   "Win code : 54637",
                            //   style: TextStyle(
                            //       color: Colors.white),
                            // ),
                            // SizedBox(height: 20),
                            Scratcher(
                              brushSize: 70,
                              threshold: 70,
                              accuracy: ScratchAccuracy.low,
                              color: Colors.blue,
                              image: Image.asset(
                                "assets/images/outerimage.png",
                                fit: BoxFit.fill,
                              ),
                              onChange: (value) =>
                                  print("Scratch progress: $value%"),
                              onThreshold: () {
                                Provider.of<Wins>(context, listen: false)
                                    .isHighLighted = false;
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.white,
                                  height: 300,
                                  width: 300,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          icon: Icon(Icons.share),
                                          onPressed: () {
                                            screenshotController
                                                .capture()
                                                .then((img) async {
                                              final String path =
                                                  (await getTemporaryDirectory())
                                                      .path;
                                              await img.copy(
                                                  "$path/screenshot_win.png");
                                              Share.shareFiles(<String>[
                                                "$path/screenshot_win.png"
                                              ],
                                                  text:
                                                      "I have won 1000 rs in Goldcoin");
                                            });
                                          },
                                        ),
                                      ),
                                      Image.asset(
                                        "assets/images/newimage.png",
                                        fit: BoxFit.contain,
                                        width: 150,
                                        height: 150,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Better Luck",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 25,
                                            ),
                                          ),
                                          Text(
                                            "next time",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Scratch the card to win the price",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Container(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: isHighLighted ? 20 : 25,
                    child: Icon(
                      Icons.star_border,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Wins",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            width: size.width / 5,
            height: 80,
            // color: Colors.white,
          ),
        ),
      ],
    );
  }
}
