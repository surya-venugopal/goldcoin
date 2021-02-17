// import 'package:connectycube_sdk/connectycube_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:stocklot/screens/call_screen/call_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class PickUpScreen extends StatefulWidget {
//   final P2PSession callSession;
//   final String personId;
//   final String personName;
//   final String personDp;
//   final String myId;
//
//   PickUpScreen(
//     this.callSession,
//     this.personId,
//     this.personName,
//     this.personDp,
//     this.myId,
//   );
//
//   @override
//   _PickUpScreenState createState() => _PickUpScreenState();
// }
//
// class _PickUpScreenState extends State<PickUpScreen> {
//   @override
//   void initState() {
//     FlutterRingtonePlayer.playRingtone();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     FlutterRingtonePlayer.stop();
//     super.dispose();
//   }
//
//   void _rejectCall(P2PSession callSession) {
//     var db = FirebaseFirestore.instance;
//
//     db.collection("User").doc(widget.myId).get().then((doc) {
//       if (doc.data()['whoCalled'] == "" || doc.data()['whoCalled'] == null) {
//         callSession.reject();
//       } else {
//         db
//             .collection("User")
//             .doc(widget.myId)
//             .update({"whoCalled": ""}).then((value) {
//           callSession.reject();
//         });
//       }
//     });
//
//     Navigator.of(context).pop();
//   }
//
//   void _acceptCall(BuildContext context, P2PSession callSession) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CallScreen(callSession, true, widget.personId,
//             widget.personName, widget.personDp),
//       ),
//     );
//   }
//
//   Future<bool> _onBackPressed(BuildContext context) {
//     return Future.value(false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     // final user = Provider.of<Users>(context, listen: false).getUser;
//     return WillPopScope(
//       onWillPop: () => _onBackPressed(context),
//       child: Scaffold(
//         body: SafeArea(
//           child: Container(
//             height: size.height,
//             width: size.width,
//             decoration: BoxDecoration(
//               color: Colors.white,
//             ),
//             padding: const EdgeInsets.all(50.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "Incoming Video Call",
//                   style: TextStyle(
//                     color: Colors.deepPurpleAccent,
//                     fontWeight: FontWeight.w300,
//                     fontSize: 15,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   widget.personName,
//                   style: TextStyle(
//                     color: Colors.deepPurpleAccent,
//                     fontWeight: FontWeight.w900,
//                     fontSize: 20,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(200),
//                   child: Image.network(
//                     widget.personDp,
//                     height: 200,
//                     width: 200,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       children: [
//                         RawMaterialButton(
//                           onPressed: () {
//                             FlutterRingtonePlayer.stop();
//                             _rejectCall(widget.callSession);
//                           },
//                           splashColor: Colors.deepPurpleAccent,
//                           fillColor: Colors.white,
//                           elevation: 10.0,
//                           shape: CircleBorder(),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Icon(
//                               Icons.call_end,
//                               size: 30.0,
//                               color: Colors.deepPurpleAccent,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 10.0, horizontal: 2.0),
//                           child: Text(
//                             "end",
//                             style: TextStyle(
//                                 fontSize: 15.0, color: Colors.deepPurpleAccent),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         RawMaterialButton(
//                           onPressed: () {
//                             FlutterRingtonePlayer.stop();
//                             _acceptCall(context, widget.callSession);
//                           },
//                           splashColor: Colors.deepPurpleAccent,
//                           fillColor: Colors.white,
//                           elevation: 10.0,
//                           shape: CircleBorder(),
//                           child: Padding(
//                             padding: const EdgeInsets.all(15.0),
//                             child: Icon(
//                               Icons.call,
//                               size: 30.0,
//                               color: Colors.deepPurpleAccent,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(
//                               vertical: 10.0, horizontal: 2.0),
//                           child: Text(
//                             "attend",
//                             style: TextStyle(
//                                 fontSize: 15.0, color: Colors.deepPurpleAccent),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:stocklot/providers/call.dart';
import 'package:stocklot/providers/call_methods.dart';
import 'package:stocklot/providers/permissions.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/screens/call_screen/call_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PickUpScreen extends StatefulWidget {
  final Call call;

  PickUpScreen({this.call});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  final CallMethods callMethods = CallMethods();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    FlutterRingtonePlayer.playRingtone();
    db.collection("Calls")
        .doc(widget.call.roomId)
        .collection("Members")
        .doc(Provider.of<Users>(context, listen: false).getUser.phone)
        .snapshots()
        .listen((event) {
      switch (event.data()) {
        case null:
          Navigator.of(context).pop();
          break;
        default:
          break;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    FlutterRingtonePlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
            // CachedImage(
            //   call.callerPic,
            //   isRound: true,
            //   radius: 180,
            // ),
            // SizedBox(height: 15),
            Text(
              widget.call.callerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    var db = FirebaseFirestore.instance;
                    db
                        .collection("User")
                        .doc(Provider.of<Users>(context, listen: false)
                            .getUser
                            .phone)
                        .update({"whoCalled": ""});
                    await callMethods.endCall(call: widget.call);
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    if (await Permissions
                        .cameraAndMicrophonePermissionsGranted()) {
                      FlutterRingtonePlayer.stop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CallScreen(call: widget.call),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
