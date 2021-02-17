import 'package:flutter/material.dart';
import 'package:stocklot/providers/call.dart';
import 'package:stocklot/providers/call_methods.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/screens/call_screen/call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static String roomId;

  static dial({UserModel from, UserModel to, context}) async {
    if (int.parse(from.phone.substring(3)) < int.parse(to.phone.substring(3))) {
      roomId = from.phone.substring(3) + to.phone.substring(3);
    } else {
      roomId = to.phone.substring(3) + from.phone.substring(3);
    }
    Call call = Call(
      callerId: from.phone,
      callerName: from.name,
      callerPic: from.dp,
      receiverId: to.phone,
      receiverName: to.name,
      receiverPic: to.dp,
      roomId: roomId,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}
