import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:stocklot/providers/pass_code.dart';

import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PassCode extends StatefulWidget {
  static const routeName = "/passcode";
  var pin = "";
  final topic;
  final isInit;

  PassCode(this.topic, this.isInit);

  @override
  _PassCodeState createState() => _PassCodeState();
}

class _PassCodeState extends State<PassCode> {
  String p1 = "";
  String p2 = "";
  String p3 = "";
  String p4 = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Provider.of<PassCodeModel>(context).pin = "0";
        if (widget.isInit) {
          SystemNavigator.pop();
        }
        return true;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20, left: 5, right: 5),
          margin: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Ad(),
              SizedBox(height: 10),
              Text(
                widget.topic,
                style: TextStyle(fontSize: 28),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            p1,
                            style: TextStyle(fontSize: 24),
                          ),
                          Container(
                            color: Colors.black45,
                            width: 40,
                            height: 2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            p2,
                            style: TextStyle(fontSize: 24),
                          ),
                          Container(
                            color: Colors.black45,
                            width: 40,
                            height: 2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            p3,
                            style: TextStyle(fontSize: 24),
                          ),
                          Container(
                            color: Colors.black45,
                            width: 40,
                            height: 2,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            p4,
                            style: TextStyle(fontSize: 24),
                          ),
                          Container(
                            color: Colors.black45,
                            width: 40,
                            height: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "1";
                              p1 = "1";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "1";
                              p2 = "1";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "1";
                              p3 = "1";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "1";
                              p4 = "1";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            "1",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "2";
                              p1 = "2";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "2";
                              p2 = "2";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "2";
                              p3 = "2";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "2";
                              p4 = "2";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("2", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "3";
                              p1 = "3";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "3";
                              p2 = "3";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "3";
                              p3 = "3";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "3";
                              p4 = "3";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("3", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "4";
                              p1 = "4";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "4";
                              p2 = "4";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "4";
                              p3 = "4";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "4";
                              p4 = "4";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("4", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "5";
                              p1 = "5";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "5";
                              p2 = "5";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "5";
                              p3 = "5";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "5";
                              p4 = "5";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("5", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "6";
                              p1 = "6";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "6";
                              p2 = "6";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "6";
                              p3 = "6";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "6";
                              p4 = "6";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("6", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "7";
                              p1 = "7";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "7";
                              p2 = "7";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "7";
                              p3 = "7";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "7";
                              p4 = "7";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("7", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "8";
                              p1 = "8";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "8";
                              p2 = "8";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "8";
                              p3 = "8";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "8";
                              p4 = "8";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("8", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "9";
                              p1 = "9";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "9";
                              p2 = "9";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "9";
                              p3 = "9";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "9";
                              p4 = "9";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("9", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).canvasColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(widget.pin);
                          if (widget.pin.toString().length == 0) {
                            setState(() {
                              widget.pin += "0";
                              p1 = "0";
                            });
                          } else if (widget.pin.toString().length == 1) {
                            setState(() {
                              widget.pin += "0";
                              p2 = "0";
                            });
                          } else if (widget.pin.toString().length == 2) {
                            setState(() {
                              widget.pin += "0";
                              p3 = "0";
                            });
                          } else if (widget.pin.toString().length == 3) {
                            setState(() {
                              widget.pin += "0";
                              p4 = "0";
                              Provider.of<PassCodeModel>(context, listen: false)
                                  .setPin(widget.pin);
                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).primaryColor,
                          child:
                              Text("0", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.pin =
                                widget.pin.substring(0, widget.pin.length - 1);
                            if (widget.pin.toString().length == 0) {
                              p1 = "";
                            }
                            if (widget.pin.toString().length == 1) {
                              p2 = "";
                            }
                            if (widget.pin.toString().length == 2) {
                              p3 = "";
                            }
                          });
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Theme.of(context).canvasColor,
                          child: Icon(
                            Icons.backspace,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Ad extends StatefulWidget {

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () async {
      doc = await db.collection("Ads").doc("passScreen").get();
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
        child:Stack(
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
                  if (doc !=null && doc.data()['type'] == 1)
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
