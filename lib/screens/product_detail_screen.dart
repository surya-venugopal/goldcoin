import 'package:stocklot/providers/product.dart';
import '../main.dart';
import '../providers/user.dart';
import '../widgets/detail_screen_components/body.dart';
import '../widgets/detail_screen_components/buildBottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "ProductDetail";

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context).settings.arguments as Product;
    var user = Provider.of<Users>(context, listen: false).getUser;
    product.addViewCount(user.phone,user.name,user.rating);
    final appBar = AppBar(
      title: Text(product.title),
      //backgroundColor: Colors.white70,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          height: 16,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        SizedBox(width: kDefaultPaddin / 2),
      ],
    );
    print("\n\n\n\n\n${product.personId}");
    return Scaffold(
        appBar: appBar,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(gradient: MyApp.getGradient()),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              height: double.infinity,
              // height: (MediaQuery.of(context).size.height -
              //         appBar.preferredSize.height -
              //         MediaQuery.of(context).padding.top) *
              //     1,
              width: MediaQuery.of(context).size.width,
              child: Body(),
            ),
            if (product.personId !=
                Provider.of<Users>(context, listen: false).getUser.phone)
              Positioned(
                bottom: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: BuildBottom(product),
                ),
              ),
          ],
        ),
      );
  }
}
