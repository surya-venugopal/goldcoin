import '../main.dart';
import '../providers/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        decoration: BoxDecoration(gradient: MyApp.getGradient()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.blue,
                        child: Text("Logo"),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Welcome to \nGoldcoin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[200])),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(color: Colors.grey[300])),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Mobile Number (10 digit)"),
                    controller: _phoneController,
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      padding: EdgeInsets.all(10),
                      color: Theme.of(context).accentColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if (_phoneController.text.trim().length == 10) {
                          final phone = "+91" + _phoneController.text.trim();
                          AuthProvider().loginWithPhone(phone, context);
                        } else {
                          Fluttertoast.showToast(msg: "Invalid phone number");
                        }
                      },
                      child: Text("Confirm",style: TextStyle(fontSize: 16),),
                    ),
                  )
                ],
              ),
            ),
            Text(
              "By joining this community, you agree to the terms and conditions",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
    // body: SingleChildScrollView(
    //   child: Container(
    //     padding: EdgeInsets.all(32),
    //     child: Form(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Text(
    //             "Login",
    //             style: TextStyle(
    //                 color: Theme.of(context).primaryColor,
    //                 fontSize: 36,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //           SizedBox(
    //             height: 16,
    //           ),
    //           TextFormField(
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //                 enabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(color: Colors.grey[200])),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.all(Radius.circular(8)),
    //                     borderSide: BorderSide(color: Colors.grey[300])),
    //                 filled: true,
    //                 fillColor: Colors.grey[100],
    //                 hintText: "Mobile Number"),
    //             controller: _phoneController,
    //           ),
    //           SizedBox(
    //             height: 16,
    //           ),
    //           Container(
    //             width: double.infinity,
    //             child: FlatButton(
    //               child: Text("LOGIN"),
    //               textColor: Colors.white,
    //               padding: EdgeInsets.all(16),
    //               onPressed: () {
    //                 final phone = "+91"+_phoneController.text.trim();
    //
    //                 AuthProvider().loginWithPhone(phone, context);
    //               },
    //               color: Theme.of(context).primaryColor,
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // ));
  }
}
