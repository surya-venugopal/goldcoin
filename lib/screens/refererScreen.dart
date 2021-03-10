import 'package:flutter/material.dart';
import 'package:stocklot/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RefererScreen extends StatefulWidget {
  static const routeName = "/referer";

  @override
  _RefererScreenState createState() => _RefererScreenState();
}

class _RefererScreenState extends State<RefererScreen> {
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
        padding: EdgeInsets.all(20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: MyApp.getGradient()),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Hero(
                  tag: "LOGO",
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blue,
                    child: Text("Logo"),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                "Referer's phone",
                style: TextStyle(fontSize: 20, color: Colors.white),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(MainScreen.routeName);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          fontSize: 16, decoration: TextDecoration.underline),
                    ),
                  ),
                  // SizedBox(width: 20,),
                  FlatButton(
                    padding: EdgeInsets.all(10),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_phoneController.text.trim().length == 10) {
                        final phone = "+91" + _phoneController.text.trim();

                        FirebaseFirestore.instance
                            .collection("User")
                            .doc(phone)
                            .collection("Referers")
                            .doc(Provider.of<Users>(context, listen: false)
                                .getUser
                                .phone)
                            .set({
                          "id": Provider.of<Users>(context, listen: false)
                              .getUser
                              .phone
                        });
                        Navigator.of(context)
                            .pushReplacementNamed(MainScreen.routeName);
                      } else {
                        Fluttertoast.showToast(msg: "Invalid phone number");
                      }
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
