
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/providers/pass_code.dart';
import '../main.dart';
import '../screens/pass_code.dart';
import '../providers/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfilePersonalInfoInit extends StatefulWidget {
  static const routeName = '/profile-init';

  @override
  _ProfilePersonalInfoInitState createState() =>
      _ProfilePersonalInfoInitState();
}

class _ProfilePersonalInfoInitState extends State<ProfilePersonalInfoInit> {
  DateTime selectedDate;
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  int individualOrCompany = 0;
  int pin = 0;
  int userVideoId;
  bool isLoading = false;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging fbm = FirebaseMessaging.instance;

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    addressController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
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
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: size.width * 1 / 5,
                              horizontal: size.width * 1 / 20),
                          child: Form(
                            key: _formKey,
                            child: Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: nameController,
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        // hintText: 'What do people call you?',
                                        labelText: 'Name *',
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      children: [
                                        Radio(
                                          value: 0,
                                          groupValue: individualOrCompany,
                                          onChanged: (value) {
                                            setState(() {
                                              individualOrCompany = value;
                                            });
                                          },
                                        ),
                                        Text("Individual"),
                                        SizedBox(width: 20),
                                        Radio(
                                          value: 1,
                                          groupValue: individualOrCompany,
                                          onChanged: (value) {
                                            setState(() {
                                              individualOrCompany = value;
                                            });
                                          },
                                        ),
                                        Text("Company"),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: addressController,
                                      autovalidateMode: AutovalidateMode.always,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.my_location),
                                        labelText: 'Address *',
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      autovalidateMode: AutovalidateMode.always,
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          icon: Icon(Icons.email),
                                          labelText: "Email"),
                                    ),
                                    SizedBox(height: 15),
                                    TextFormField(
                                      controller: dobController,
                                      autovalidateMode: AutovalidateMode.always,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1965),
                                          lastDate: DateTime.now(),
                                        ).then((value) {
                                          if (value == null) return;
                                          setState(() {
                                            selectedDate = value;
                                            dobController.text = selectedDate
                                                .toString()
                                                .substring(0, 10);
                                          });
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.date_range),
                                        labelText: 'Date of birth *',
                                      ),
                                    ),
                                    SizedBox(height: 25),
                                    TextFormField(
                                      controller: descriptionController,
                                      maxLines: 4,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          labelText:
                                              "Short description about you"),
                                    ),
                                    // FlatButton(
                                    //   onPressed: () {
                                    //     Navigator.of(context)
                                    //         .push(
                                    //           MaterialPageRoute(
                                    //               builder: (ctx) => PassCode(
                                    //                   "Enter new pin", false)),
                                    //         )
                                    //         .then((value) => validatePin(
                                    //             Provider.of<PassCodeModel>(context,
                                    //                     listen: false)
                                    //                 .pin));
                                    //   },
                                    //   child: Text(
                                    //     "Set new pin",
                                    //     style: TextStyle(
                                    //         color: Theme.of(context).accentColor),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                            builder: (ctx) => PassCode("Enter New Pin", false)),
                      )
                      .then((value) => validatePin(
                          Provider.of<PassCodeModel>(context, listen: false)
                              .pin));
                }
              },
              child: Icon(Icons.navigate_next),
            ),
    );
  }

  validatePin(String pin) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (ctx) => PassCode("Re-Enter Pin", false)),
        )
        .then((value) => validateRePin(
            pin, Provider.of<PassCodeModel>(context, listen: false).pin));
  }

  validateRePin(String pin1, String pin2) async {
    if (pin1 == pin2) {
      Fluttertoast.showToast(
          msg: "Pin set successfully", toastLength: Toast.LENGTH_LONG);

      Provider.of<Users>(context, listen: false)
          .updatePin(Provider.of<PassCodeModel>(context, listen: false).pin);
      if (Provider.of<PassCodeModel>(context, listen: false).pin != null) {
        setState(() {
          isLoading = true;
        });
        String fcmToken;
        if(kIsWeb){
          // fcmToken = await fbm.getToken(vapidKey: "BHdgq1CxatjRYWc0ptigq4RUAleadt4KpL4Bqflw-J84tTziLuF9Dq13p4yO14hn4opjf4Q2jvblFGnwT_D9Xtc");
          fcmToken = "";
        }
        else{
          fcmToken = await fbm.getToken();
        }


        var userProvider = Provider.of<Users>(context, listen: false);
        var user = userProvider.getUser;
        // CubeUser cubeUser = CubeUser(
        //   login: user.phone,
        //   password: user.phone,
        // );
        //
        // await createSession();
        // CubeUser users = await signUp(cubeUser);

        // userVideoId = users.id;

        print(userVideoId);
        userProvider.update(
          name: nameController.text,
          dob: selectedDate,
          address: addressController.text,
          isLoggedIn: true,
          fcmToken: fcmToken,
          rating: 10,
          pin: Provider.of<PassCodeModel>(context, listen: false).pin,
          mailId: emailController.text,
          description: descriptionController.text,
          individualOrCompany: individualOrCompany,
          // userVideoId: userVideoId,
          isVerified: false
        );

        db
            .collection("User")
            .doc(user.phone)
            .set(userProvider.getMap)
            .then((value) => Navigator.of(context).pushReplacementNamed("/"))
            .catchError((error) {
          print(error);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Please set a pin", toastLength: Toast.LENGTH_SHORT);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Pin mis-match. Please retry!", toastLength: Toast.LENGTH_LONG);
    }
  }
}
