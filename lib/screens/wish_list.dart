import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/providers/chats.dart';
import 'package:stocklot/providers/product.dart';

import 'package:provider/provider.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/screens/product_detail_screen.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constant.dart';

// ignore: must_be_immutable
class WishList extends StatelessWidget {
  static const routeName = "/wishlist";

  var db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = Provider.of<Users>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("WishList"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
            stream: db
                .collection("Product")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              var products = snapshot.data.docs;
              return products.length > 0
                  ? Container(
                      width: size.width,
                      child: ListView.builder(
                        //padding: const EdgeInsets.all(10.0),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = Product(
                            time: (products[index].data()['time'] as Timestamp)
                                .toDate(),
                            videoUrl: products[index].data()['videoUrl'],
                            personId: products[index].data()['person_id'],
                            quantity: products[index].data()['quantity'],
                            id: products[index].id,
                            personName: products[index].data()['personName'],
                            title: products[index].data()['title'],
                            description: products[index].data()['description'],
                            price: products[index].data()['price'],
                            imageUrl: List<String>.from(
                                products[index].data()['imageUrl']),
                            isAd: products[index].data()['isAd'],
                            isOffer: products[index].data()['isOffer'],
                            category: products[index].data()['category'],
                          );
                          return StreamBuilder(
                              stream: db
                                  .collection("Product")
                                  .doc(snapshot.data.docs[index].id)
                                  .collection("favorites")
                                  .doc(user.phone)
                                  .snapshots(),
                              builder: (_,
                                  AsyncSnapshot<DocumentSnapshot> snapshot1) {
                                if (snapshot1.hasError) {
                                  return Text('Something went wrong');
                                }
                                if (snapshot1.connectionState ==
                                    ConnectionState.waiting) {
                                  // return Center(
                                  //     child: CircularProgressIndicator());
                                  return Container();
                                }
                                if (snapshot1.data.exists) {
                                  product.isFavorite = true;
                                  return Container(
                                    height: size.width<370?size.height / 2 + 30:size.height / 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            ProductDetailScreen.routeName,
                                            arguments: product
                                            // {
                                            //   'id': product.id,
                                            //   'index': index,
                                            //   'isFav': isFavorite,
                                            // }
                                            );
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Stack(
                                              alignment: Alignment.bottomLeft,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(10),
                                                      topLeft:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    height: size.height / 3,
                                                    width: double.infinity,
                                                    child: Hero(
                                                      tag: "${product.id}",
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: product
                                                              .imageUrl[0],
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(50),
                                                    ),
                                                    color: Colors.grey[300],
                                                  ),

                                                  child: IconButton(
                                                    iconSize: 20,
                                                    icon: Icon(
                                                      product.isFavorite
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                    onPressed: () {
                                                      product.toggleFavorites(
                                                          Provider.of<Users>(
                                                                  context,
                                                                  listen: false)
                                                              .getUser
                                                              .phone);
                                                      product.isFavorite
                                                          ? Toast.show(
                                                              '${product.title} is added to favorites',
                                                              context,
                                                              duration: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  Toast.BOTTOM)
                                                          : Toast.show(
                                                              '${product.title} is removed from favorites',
                                                              context,
                                                              duration: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  Toast.BOTTOM);
                                                    },
                                                  ),

                                                  // CartButton(cart: cart, product: product),
                                                ),
                                              ],
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical:
                                                            kDefaultPaddin / 4),
                                                child: Text(
                                                  product.title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${product.quantity}",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            if (product.personId !=
                                                Provider.of<Users>(context,
                                                        listen: false)
                                                    .getUser
                                                    .phone)
                                              GestureDetector(
                                                onTap: () async {
                                                  Toast.show(
                                                      "Notification sent successfully!",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                  await Provider.of<Chats>(
                                                          context,
                                                          listen: false)
                                                      .wantToTalk(
                                                          product.personId,
                                                          Provider.of<Users>(
                                                                  context,
                                                                  listen: false)
                                                              .getUser
                                                              .phone,
                                                          context,product.title);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 50,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Notify Seller",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  product.isFavorite = false;
                                  return Container();
                                }
                              });
                        },
                      ),
                    )
                  : Container(
                      height: size.height * 1 / 5,
                      child: Center(child: Text("No items found!")),
                    );
            }),
      ),
    );
  }
}
