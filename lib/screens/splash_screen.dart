import 'package:stocklot/screens/main_screen.dart';

import '../providers/user.dart';
import '../screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SplashPage();
          if (!snapshot.hasData || snapshot.data == null) {
            return LoginPage();
          } else if (snapshot.data.phoneNumber != null) {
            Provider.of<Users>(context, listen: false)
                .set(snapshot.data.phoneNumber);
          }

          return MainScreen();
        },
      ),
    );
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
