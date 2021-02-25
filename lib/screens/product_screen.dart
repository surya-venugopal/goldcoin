import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklot/main.dart';
import 'package:stocklot/providers/product.dart';
import 'package:stocklot/providers/user.dart';
import 'package:stocklot/widgets/ad_item.dart';
import 'package:stocklot/widgets/product_item.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'search_products.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = "/main-page";
  var db = FirebaseFirestore.instance;




  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    var user = Provider
        .of<Users>(context, listen: false)
        .getUser;
    var category = ModalRoute
        .of(context)
        .settings
        .arguments;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(category),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchProducts.routeName);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: MyApp.getGradient()),
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Promoted",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // StreamBuilder(
                //     stream: db
                //         .collection("Product")
                //         .where("category", isEqualTo: category)
                //         .where("isAd", isEqualTo: 0)
                //         .orderBy("time", descending: true)
                //         .limit(5)
                //         .snapshots(),
                //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //       if (snapshot.hasError) {
                //         return Text('Something went wrong');
                //       }
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return Center(child: CircularProgressIndicator());
                //       }
                //       var products = snapshot.data.docs;
                //       return products.length > 0
                //           ? Container(
                //         height: size.height * 0.45,
                //         width: double.infinity,
                //         child: ListView.builder(
                //           scrollDirection: Axis.horizontal,
                //           //padding: const EdgeInsets.all(10.0),
                //           itemCount: products.length,
                //           itemBuilder: (context, index) {
                //             var product = Product(
                //               time: (products[index].data()['time']
                //               as Timestamp)
                //                   .toDate(),
                //               videoUrl:
                //               products[index].data()['videoUrl'],
                //               personId:
                //               products[index].data()['person_id'],
                //               quantity:
                //               products[index].data()['quantity'],
                //               id: products[index].id,
                //               personName:
                //               products[index].data()['personName'],
                //               title: products[index].data()['title'],
                //               description:
                //               products[index].data()['description'],
                //               price: products[index].data()['price'],
                //               imageUrl: List<String>.from(
                //                   products[index].data()['imageUrl']),
                //               isAd: products[index].data()['isAd'],
                //               isOffer: products[index].data()['isOffer'],
                //               category:
                //               products[index].data()['category'],
                //             );
                //
                //             return StreamBuilder(
                //                 stream: db
                //                     .collection("Product")
                //                     .doc(snapshot.data.docs[index].id)
                //                     .collection("favorites")
                //                     .doc(user.phone)
                //                     .snapshots(),
                //                 builder: (_,
                //                     AsyncSnapshot<DocumentSnapshot>
                //                     snapshot1) {
                //                   if (snapshot1.hasError) {
                //                     return Text('Something went wrong');
                //                   }
                //                   if (snapshot1.connectionState ==
                //                       ConnectionState.waiting) {
                //                     // return Center(
                //                     //     child: CircularProgressIndicator());
                //                     return Container();
                //                   }
                //                   if (snapshot1.data.exists) {
                //                     product.isFavorite = true;
                //                   } else {
                //                     product.isFavorite = false;
                //                   }
                //
                //                   return CarouselSlider(
                //                     options: CarouselOptions(
                //                         autoPlayInterval:
                //                         Duration(seconds: 5)),
                //                     items: products
                //                         .map((e) => AdItem(product))
                //                         .toList(),
                //                   );
                //                 });
                //           },
                //         ),
                //       )
                //           : Container(
                //         height: size.height * 1 / 5,
                //         child: Center(
                //             child: Text(
                //               "No items found!",
                //               style: TextStyle(color: Colors.white),
                //             )),
                //       );
                //     })

                AdItem(category)
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Container(
                  //width: 150,
                  alignment: Alignment.topLeft,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   gradient: LinearGradient(colors: [Color(0xFF915FB5),Color(0xFFCA436B)],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,),
                  // ),
                  // padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Offers",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                    stream: db
                        .collection("Product")
                        .where("category", isEqualTo: category)
                        .where("isOffer", isEqualTo: 0)
                        .orderBy("time", descending: true)
                        .limit(10)
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
                        height: size.height * 0.25,
                        width: size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          //padding: const EdgeInsets.all(10.0),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            var product = Product(
                              time: (products[index].data()['time']
                              as Timestamp)
                                  .toDate(),
                              videoUrl:
                              products[index].data()['videoUrl'],
                              personId:
                              products[index].data()['person_id'],
                              quantity:
                              products[index].data()['quantity'],
                              id: products[index].id,
                              personName:
                              products[index].data()['personName'],
                              title: products[index].data()['title'],
                              description:
                              products[index].data()['description'],
                              price: products[index].data()['price'],
                              imageUrl: List<String>.from(
                                  products[index].data()['imageUrl']),
                              isAd: products[index].data()['isAd'],
                              isOffer: products[index].data()['isOffer'],
                              category:
                              products[index].data()['category'],
                            );
                            return StreamBuilder(
                                stream: db
                                    .collection("Product")
                                    .doc(snapshot.data.docs[index].id)
                                    .collection("favorites")
                                    .doc(user.phone)
                                    .snapshots(),
                                builder: (_,
                                    AsyncSnapshot<DocumentSnapshot>
                                    snapshot1) {
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
                                  } else {
                                    product.isFavorite = false;
                                  }

                                  return _buildOfferProduct(product);
                                });
                          },
                        ),
                      )
                          : Container(
                        height: size.height * 1 / 5,
                        child: Center(
                            child: Text(
                              "No items found!",
                              style: TextStyle(color: Colors.white),
                            )),
                      );
                    })
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Container(
                  //width: 150,
                  alignment: Alignment.topLeft,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(10),
                  //   gradient: LinearGradient(colors: [Color(0xFF915FB5),Color(0xFFCA436B)],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,),
                  // ),
                  // padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Recent",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      // fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder(
                    stream: db
                        .collection("Product")
                        .where("category", isEqualTo: category)
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
                        height: size.height * 0.25,
                        width: size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          //padding: const EdgeInsets.all(10.0),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            var product = Product(
                              time: (products[index].data()['time']
                              as Timestamp)
                                  .toDate(),
                              videoUrl:
                              products[index].data()['videoUrl'],
                              personId:
                              products[index].data()['person_id'],
                              quantity:
                              products[index].data()['quantity'],
                              id: products[index].id,
                              personName:
                              products[index].data()['personName'],
                              title: products[index].data()['title'],
                              description:
                              products[index].data()['description'],
                              price: products[index].data()['price'],
                              imageUrl: List<String>.from(
                                  products[index].data()['imageUrl']),
                              isAd: products[index].data()['isAd'],
                              isOffer: products[index].data()['isOffer'],
                              category:
                              products[index].data()['category'],
                            );
                            return StreamBuilder(
                                stream: db
                                    .collection("Product")
                                    .doc(snapshot.data.docs[index].id)
                                    .collection("favorites")
                                    .doc(user.phone)
                                    .snapshots(),
                                builder: (_,
                                    AsyncSnapshot<DocumentSnapshot>
                                    snapshot1) {
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
                                  } else {
                                    product.isFavorite = false;
                                  }

                                  return ProductItem(product);
                                });
                          },
                        ),
                      )
                          : Container(
                        height: size.height * 1 / 5,
                        child: Center(
                            child: Text(
                              "No items found!",
                              style: TextStyle(color: Colors.white),
                            )),
                      );
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdProduct(Product product) {
    if (product.isAd == 0) {
      // return AdItem(product);
      // return
    } else {
      return null;
    }
  }

  Widget _buildOfferProduct(Product product) {
    if (product.isOffer == 0) {
      return ProductItem(product);
    } else {
      return null;
    }
  }
}
