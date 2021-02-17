import 'package:stocklot/providers/pass_code.dart';
import 'package:stocklot/screens/all_users.dart';
import 'package:stocklot/screens/friend_profile.dart';
import 'package:stocklot/screens/main_screen.dart';
import 'package:stocklot/screens/requests_screen.dart';
import 'package:stocklot/screens/search_products.dart';
import 'package:stocklot/screens/product_screen.dart';
import 'package:stocklot/screens/profile_personal_info.dart';
import 'package:stocklot/screens/profile_personal_info_init.dart';
import 'package:stocklot/screens/search_users.dart';
import 'package:stocklot/screens/who_viewed.dart';
import 'package:stocklot/screens/wish_list.dart';
import 'package:stocklot/widgets/chats_viewer.dart';

import 'providers/chats.dart';
import 'providers/user.dart';
import 'screens/add_product_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/main_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_products_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/orders.dart';
import 'providers/products.dart';

import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

const primaryColor = Color.fromRGBO(248, 54, 0, 1.00);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static LinearGradient getGradient() {
    return LinearGradient(colors: [
      // Color.fromRGBO(102, 37, 139, 1.00),
      // Color.fromRGBO(227, 6, 102, 1.00),
      primaryColor,

      Color.fromRGBO(254, 140, 0, 1.00)
    ], begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  static capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  static makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}

class _MyAppState extends State<MyApp> {
  var _isInit = true;

  // @override
  // void initState() {
  //
  //   // var fbm = FirebaseMessaging();
  //   // fbm.configure(onResume: (msg) {
  //   //   fbm = FirebaseMessaging();
  //   //   Navigator.of(context).pushNamed(ChatScreen.routeName,
  //   //       arguments: {"id": msg['data']['id'], "name": msg['data']['name']});
  //   //   return;
  //   // }, onLaunch: (msg) {
  //   //   fbm = FirebaseMessaging();
  //   //   Navigator.of(context).pushNamed(ChatScreen.routeName,
  //   //       arguments: {"id": msg['data']['id'], "name": msg['data']['name']});
  //   //    return;
  //   // });
  //
  //   super.initState();
  // }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Firebase.initializeApp();
    }
    // init(
    //   config.APP_ID,
    //   config.AUTH_KEY,
    //   config.AUTH_SECRET,
    // );
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => _isInit ? null : Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => _isInit ? null : Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => _isInit ? null : Users(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => _isInit ? null : Chats(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => _isInit ? null : PassCodeModel(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',

        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            // primaryColor: Color.fromRGBO(138, 5, 0, 1.00),
            primaryIconTheme: IconThemeData(
              color: Colors.white,
            ),
            primaryColor: primaryColor,
            accentColor: Color.fromRGBO(45, 41, 38, 1.00),
            canvasColor: Colors.white,
            primaryTextTheme:
                TextTheme(headline6: TextStyle(color: Colors.white))),
        home: _isInit ? SplashPage() : SplashScreen(),
        // home: FriendProfile("+917010450504"),
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          // OrderScreen.routeName: (ctx) => OrderScreen(),
          // WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          ProfilePersonalInfoInit.routeName: (ctx) => ProfilePersonalInfoInit(),
          ProfilePersonalInfo.routeName: (ctx) => ProfilePersonalInfo(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          AddProduct.routeName: (ctx) => AddProduct(),
          ChatViewer.routeName: (ctx) => ChatViewer(),
          ChatScreen.routeName: (ctx) => ChatScreen(),
          FriendProfile.routeName: (ctx) => FriendProfile(),
          WishList.routeName: (ctx) => WishList(),
          ProductScreen.routeName: (ctx) => ProductScreen(),
          SearchProducts.routeName: (ctx) => SearchProducts(),
          RequestScreen.routeName: (ctx) => RequestScreen(),
          WhoViewedMyProduct.routeName: (ctx) => WhoViewedMyProduct(),
          AllUsers.routeName: (ctx) => AllUsers(),
          SearchUser.routeName: (ctx) => SearchUser(),
        },
      ),
    );
  }
}
