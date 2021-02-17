import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocklot/providers/product.dart';
import 'package:stocklot/providers/user.dart';

import '../env.dart';
import 'product_detail_screen.dart';
import 'package:provider/provider.dart';

class SearchProducts extends StatefulWidget {
  static const routeName = "/search";

  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  var searchField = TextEditingController();
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;
  Algolia algolia;
  var db = FirebaseFirestore.instance;
  var isLoading = false;

  _search() async {
    setState(() {
      _searching = true;
    });

    AlgoliaQuery query = algolia.instance.index('stocklot_products');
    query = query.search(searchField.text.trim());
    print(query);
    var objects = await query.getObjects();
    _results = objects.hits;

    setState(() {
      _searching = false;
    });
  }

  @override
  void initState() {
    algolia = Algolia.init(
      applicationId: 'LZKX0WD9CY',
      apiKey: '1eb28c1524592cdd52247c83ea61d54b',
    );
    super.initState();
  }

  @override
  void dispose() {
    searchField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Users>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: searchField,
                    // autofocus: true,
                    onChanged: (text) {
                      if (text.trim().length > 1) _search();
                    },
                    decoration:
                        InputDecoration(hintText: "Enter product name..."),
                  ),
                  Expanded(
                    child: _searching == true
                        ? Center(
                            child: Text("Searching, please wait..."),
                          )
                        : _results.length == 0
                            ? Center(
                                child: Text("No results found."),
                              )
                            : ListView.builder(
                                itemCount: _results.length,
                                itemBuilder: (BuildContext ctx, int index) {
                                  AlgoliaObjectSnapshot snap = _results[index];

                                  return Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snap.data["imageUrl"]),
                                        ),
                                        title: Text(snap.data["title"]),
                                        subtitle: Text(snap.data["personName"]),
                                        onTap: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          var doc = await db
                                              .collection("Product")
                                              .doc(snap.objectID)
                                              .get();
                                          var isLiked = await db
                                              .collection("Product")
                                              .doc(snap.objectID)
                                              .collection("favorites")
                                              .doc(user.phone)
                                              .get();
                                          var product = Product(
                                            time: (doc.data()['time']
                                                    as Timestamp)
                                                .toDate(),
                                            videoUrl: doc.data()['videoUrl'],
                                            personId: doc.data()['person_id'],
                                            quantity: doc.data()['quantity'],
                                            id: doc.id,
                                            personName:
                                                doc.data()['personName'],
                                            title: doc.data()['title'],
                                            description:
                                                doc.data()['description'],
                                            price: doc.data()['price'],
                                            imageUrl: List<String>.from(
                                                doc.data()['imageUrl']),
                                            isAd: doc.data()['isAd'],
                                            isOffer: doc.data()['isOffer'],
                                            category: doc.data()['category'],
                                          );
                                          if (isLiked.exists) {
                                            product.isFavorite = true;
                                          } else {
                                            product.isFavorite = false;
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.of(context).pushNamed(
                                              ProductDetailScreen.routeName,
                                              arguments: product);
                                        },
                                      ),
                                      Divider(
                                        thickness: 1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
    );
  }
}
