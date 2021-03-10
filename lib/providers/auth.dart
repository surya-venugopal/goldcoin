import 'package:stocklot/screens/refererScreen.dart';
import 'user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthProvider {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> logOut() async {
  //   try {
  //     await _auth.signOut();
  //   } catch (e) {
  //     print("error logging out");
  //   }
  // }
  //
  // Future<bool> loginWithGoogle() async {
  //   try {
  //     GoogleSignIn googleSignIn = GoogleSignIn();
  //     GoogleSignInAccount account = await googleSignIn.signIn();
  //     if (account == null) return false;
  //     UserCredential res =
  //         await _auth.signInWithCredential(GoogleAuthProvider.credential(
  //       idToken: (await account.authentication).idToken,
  //       accessToken: (await account.authentication).accessToken,
  //     ));
  //     if (res.user == null) return false;
  //     return true;
  //   } catch (e) {
  //     print(e.message);
  //     print("Error logging with google");
  //     return false;
  //   }
  // }

  Future<void> loginWithPhone(String phone, BuildContext context) async {
    final _codeController = TextEditingController();
    FirebaseAuth _auth = FirebaseAuth.instance;
    bool isWeb = kIsWeb;
    if (isWeb) {
      ConfirmationResult confirmationResult =
          await _auth.signInWithPhoneNumber(phone);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Enter OTP"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _codeController,
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Confirm"),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () async {
                    final code = _codeController.text.trim();
                    UserCredential result =
                        await confirmationResult.confirm(code);

                    User user = result.user;

                    if (user != null) {
                      Provider.of<Users>(context, listen: false).set(phone);
                      Navigator.pushReplacementNamed(
                          context, RefererScreen.routeName);
                    } else {
                      print("Error");
                    }
                  },
                )
              ],
            );
          });
    } else {
      _auth.verifyPhoneNumber(
          phoneNumber: phone,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential credential) async {
            Navigator.of(context).pop();

            UserCredential result =
                await _auth.signInWithCredential(credential);

            User user = result.user;

            if (user != null) {
              Provider.of<Users>(context, listen: false).set(phone);
              Navigator.pushReplacementNamed(context, RefererScreen.routeName);
            } else {
              Fluttertoast.showToast(msg: "Error");
            }
          },
          verificationFailed: (FirebaseAuthException exception) {
            Fluttertoast.showToast(msg: exception.toString());
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Enter OTP"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          UserCredential result =
                              await _auth.signInWithCredential(credential);

                          User user = result.user;

                          if (user != null) {
                            Provider.of<Users>(context, listen: false)
                                .set(phone);
                            Navigator.pushReplacementNamed(
                                context, RefererScreen.routeName);
                          } else {
                            Fluttertoast.showToast(msg: "Error");
                          }
                        },
                      )
                    ],
                  );
                });
          },
          codeAutoRetrievalTimeout: (id) => {});
    }
  }
}
