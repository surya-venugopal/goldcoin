import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:stocklot/providers/pass_code.dart';
import '../main.dart';
import '../screens/pass_code.dart';
import '../providers/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfilePersonalInfo extends StatefulWidget {
  static const routeName = '/profile';

  @override
  _ProfilePersonalInfoState createState() => _ProfilePersonalInfoState();
}

class _ProfilePersonalInfoState extends State<ProfilePersonalInfo> {
  // DateTime selectedDate;
  final nameController = TextEditingController();
  // final dobController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  var individualOrCompany;
  bool isVerified = false;
  int rating;
  String pin;
  DateTime endTime;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseMessaging fbm = FirebaseMessaging.instance;

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    // Provider.of<Users>(context, listen: false).getInfoFromDb;
    nameController.text =
        Provider.of<Users>(context, listen: false).getUser.name;
    // selectedDate = Provider.of<Users>(context, listen: false).getUser.dob;
    // dobController.text = Provider.of<Users>(context, listen: false)
    //     .getUser
    //     .dob
    //     .toString()
    //     .substring(0, 10);
    addressController.text =
        Provider.of<Users>(context, listen: false).getUser.address;
    emailController.text =
        Provider.of<Users>(context, listen: false).getUser.mailId;
    descriptionController.text =
        Provider.of<Users>(context, listen: false).getUser.description;
    individualOrCompany =
        Provider.of<Users>(context, listen: false).getUser.individualOrCompany;
    rating = Provider.of<Users>(context, listen: false).getUser.rating;
    Provider.of<PassCodeModel>(context, listen: false).pin =
        Provider.of<Users>(context, listen: false).getUser.pin;
    isVerified = Provider.of<Users>(context, listen: false).getUser.isVerified;
    endTime = Provider.of<Users>(context, listen: false).getUser.endTime;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    // dobController.dispose();
    addressController.dispose();
    emailController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  var isUploading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isUploading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: MyApp.getGradient()),
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SingleChildScrollView(
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
                                    GestureDetector(
                                      onTap: () async {
                                        FirebaseStorage db =
                                            FirebaseStorage.instance;

                                        final pickedFile =
                                            await picker.getImage(
                                                source: ImageSource.gallery,
                                                maxWidth: 300,
                                                maxHeight: 300);
                                        setState(() {
                                          _image = File(pickedFile.path);
                                          isUploading = true;
                                        });

                                        await db
                                            .ref()
                                            .child("DP")
                                            .child(Provider.of<Users>(context,
                                                    listen: false)
                                                .getUser
                                                .phone)
                                            .putData(_image.readAsBytesSync());
                                        var url = await db
                                            .ref()
                                            .child("DP")
                                            .child(Provider.of<Users>(context,
                                                    listen: false)
                                                .getUser
                                                .phone)
                                            .getDownloadURL();
                                        Provider.of<Users>(context,
                                                listen: false)
                                            .updateDp(url);

                                        setState(() {
                                          isUploading = false;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                          child: Container(
                                            color: Colors.blue,
                                            height: 100,
                                            width: 100,
                                            padding: EdgeInsets.all(2),
                                            child: _image != null
                                                ? Image.file(
                                                    _image,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Provider.of<Users>(context,
                                                                listen: false)
                                                            .getUser
                                                            .dp !=
                                                        null
                                                    ? Image.network(
                                                        Provider.of<Users>(
                                                                context,
                                                                listen: false)
                                                            .getUser
                                                            .dp,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                          Text(
                                                            "Add your photo",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )
                                                        ],
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (isVerified != null &&
                                        isVerified == true)
                                      Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.verified,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
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
                                    // TextFormField(
                                    //   controller: dobController,
                                    //   autovalidateMode: AutovalidateMode.always,
                                    //   onTap: () {
                                    //     showDatePicker(
                                    //       context: context,
                                    //       initialDate: selectedDate,
                                    //       firstDate: DateTime(1945),
                                    //       lastDate: DateTime.now(),
                                    //     ).then((value) {
                                    //       if (value == null) return;
                                    //       setState(() {
                                    //         selectedDate = value;
                                    //         dobController.text = selectedDate
                                    //             .toString()
                                    //             .substring(0, 10);
                                    //       });
                                    //     });
                                    //   },
                                    //   validator: (value) {
                                    //     if (value.isEmpty) {
                                    //       return 'Please enter some text';
                                    //     }
                                    //     return null;
                                    //   },
                                    //   decoration: const InputDecoration(
                                    //     icon: Icon(Icons.date_range),
                                    //     labelText: 'Date of birth *',
                                    //   ),
                                    // ),
                                    SizedBox(height: 25),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Rating"),
                                            Text(
                                              "${Provider.of<Users>(context, listen: false).getUser.rating} / 10",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
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
                                    SizedBox(height: 20),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(
                                              MaterialPageRoute(
                                                  builder: (ctx) => PassCode(
                                                      "Enter Existing Pin",
                                                      false)),
                                            )
                                            .then((value) =>
                                                validatePinExisting());
                                      },
                                      child: Text(
                                        "Change pin",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
      floatingActionButton: isUploading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  String fcmToken;
                  if (kIsWeb) {
                    // fcmToken = await fbm.getToken(vapidKey: "BHdgq1CxatjRYWc0ptigq4RUAleadt4KpL4Bqflw-J84tTziLuF9Dq13p4yO14hn4opjf4Q2jvblFGnwT_D9Xtc");
                    fcmToken = "";
                  } else {
                    fcmToken = await fbm.getToken();
                  }
                  Fluttertoast.showToast(
                      msg: "Done",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Theme.of(context).canvasColor,
                      textColor: Theme.of(context).primaryColor,
                      fontSize: 16.0);
                  var userProvider = Provider.of<Users>(context, listen: false);
                  userProvider.update(
                      name: nameController.text,
                      // dob: selectedDate,
                      address: addressController.text,
                      isLoggedIn: true,
                      fcmToken: fcmToken,
                      pin: Provider.of<PassCodeModel>(context, listen: false)
                          .pin,
                      mailId: emailController.text,
                      rating: rating,
                      dp: Provider.of<Users>(context, listen: false).getUser.dp,
                      description: descriptionController.text,
                      individualOrCompany: individualOrCompany,
                      isVerified: isVerified,
                      endTime: endTime,
                      userVideoId: Provider.of<Users>(context, listen: false)
                          .getUser
                          .userVideoId);
                  var user = userProvider.getUser;
                  db
                      .collection("User")
                      .doc(user.phone)
                      .set(userProvider.getMap)
                      .then((value) => Navigator.of(context).pop(user.dp))
                      .catchError((error) {
                    print(error);
                  });
                }
              },
              child: Icon(Icons.check),
            ),
    );
  }

  validatePinExisting() {
    if (Provider.of<PassCodeModel>(context, listen: false).pin ==
        Provider.of<Users>(context, listen: false).getUser.pin) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
                builder: (ctx) => PassCode("Enter New Pin", false)),
          )
          .then((value) => validatePin(
              Provider.of<PassCodeModel>(context, listen: false).pin));
    } else {
      if (Provider.of<PassCodeModel>(context, listen: false).pin != "0") {
        Fluttertoast.showToast(
            msg: "Pin mis-match. Please retry!",
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  validatePin(String pin) {
    if (Provider.of<PassCodeModel>(context, listen: false).pin != "0") {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
                builder: (ctx) => PassCode("Re-Enter Pin", false)),
          )
          .then((value) => validateRePin(
              pin, Provider.of<PassCodeModel>(context, listen: false).pin));
    }
  }

  validateRePin(String pin1, String pin2) {
    print("called");
    if (pin1 == pin2) {
      Provider.of<Users>(context, listen: false)
          .updatePin(Provider.of<PassCodeModel>(context, listen: false).pin);

      Provider.of<Users>(context, listen: false)
          .updateInfoInDb()
          .then((value) => Fluttertoast.showToast(
              msg: "Pin set successfully", toastLength: Toast.LENGTH_LONG))
          .catchError((e) {
        Fluttertoast.showToast(
            msg: "Failed! Try later", toastLength: Toast.LENGTH_LONG);
      });
    } else {
      Fluttertoast.showToast(
          msg: "Pin mis-match. Please retry!", toastLength: Toast.LENGTH_LONG);
    }
  }
}
