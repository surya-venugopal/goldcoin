// import 'package:connectycube_sdk/connectycube_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:stocklot/providers/user.dart';
// import 'file:///C:/Users/surya/Desktop/Projects/stocklot/lib/screens/call_screen/pickup_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
//
// class Environment {
//   static P2PClient callClient;
//   static P2PSession currentCall;
//
//   static void initCalls(BuildContext context) {
//     Environment.callClient = P2PClient.instance;
//     Environment.callClient.init();
//     Environment.callClient.onReceiveNewSession = (callSession) {
//       if (Environment.currentCall != null &&
//           Environment.currentCall.sessionId != callSession.sessionId) {
//         callSession.reject();
//         return;
//       }
//       showIncomingCallScreen(callSession, context);
//     };
//
//     Environment.callClient.onSessionClosed = (callSession) {
//       if (Environment.currentCall != null &&
//           Environment.currentCall.sessionId == callSession.sessionId) {
//         Environment.currentCall = null;
//       }
//     };
//   }
//
//   static void showIncomingCallScreen(
//       P2PSession callSession, BuildContext context) {
//     var db = FirebaseFirestore.instance;
//     db
//         .collection("User")
//         .where("userVideoId", isEqualTo: callSession.callerId)
//         .get()
//         .then((doc) {
//       db
//           .collection("User")
//           .doc(Provider.of<Users>(context, listen: false).getUser.phone)
//           .get()
//           .then((myDoc) async {
//         if (myDoc.data()['whoCalled'] == null ||
//             myDoc.data()['whoCalled'] == "") {
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => PickUpScreen(
//                   callSession,
//                   doc.docs[0].id,
//                   doc.docs[0].data()['name'],
//                   doc.docs[0].data()['dp'],
//                   Provider.of<Users>(context, listen: false).getUser.phone),
//             ),
//           );
//         }
//       });
//     });
//
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(
//     //     builder: (context) => PickUpScreen(callSession, "", "", ""),
//     //   ),
//     // );
//   }
//
//   static void initCustomMediaConfigs(var size) {
//     RTCMediaConfig mediaConfig = RTCMediaConfig.instance;
//     mediaConfig.minHeight = (size.height / 2 as double).toInt();
//     mediaConfig.minWidth = (size.width as double).toInt();
//     mediaConfig.minFrameRate = 15;
//   }
// }
