import 'package:cached_network_image/cached_network_image.dart';
import 'package:stocklot/main.dart';
import 'package:stocklot/providers/chats.dart';

import '../providers/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../constant.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class AdItem extends StatelessWidget {
  final Product product;

  AdItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product
                // {
                //   'id': product.id,
                //   'index': index,
                //   'isFav': isFavorite,
                // }
                );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width * 0.75,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    child: product.isAd == 1 && product.isOffer == 1
                        ? Hero(
                            tag: "${product.id}",
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrl[0],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl[0],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.amber[200],
                    ),
                    child: IconButton(
                      iconSize: 20,
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        product.toggleFavorites(
                            Provider.of<Users>(context, listen: false)
                                .getUser
                                .phone);
                        product.isFavorite
                            ? Toast.show(
                                '${product.title} is added to favorites',
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM)
                            : Toast.show(
                                '${product.title} is removed from favorites',
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1 / 4,
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPaddin / 4),
                            child: Text(
                              MyApp.capitalize(product.title),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            MyApp.capitalize("${product.quantity}"),
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  if (product.personId !=
                      Provider.of<Users>(context, listen: false).getUser.phone)
                    GestureDetector(
                      onTap: () async {
                        Toast.show("Notification sent successfully!", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        await Provider.of<Chats>(context, listen: false)
                            .wantToTalk(
                                product.personId,
                                Provider.of<Users>(context, listen: false)
                                    .getUser
                                    .phone,
                                context,
                                product.title);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 30,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Notify Seller",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          //textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   width: double.infinity,
            //   child: Text(
            //     "${product.personName}",
            //     overflow: TextOverflow.ellipsis,
            //     textAlign: TextAlign.end,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
