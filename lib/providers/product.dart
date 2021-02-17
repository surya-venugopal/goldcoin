import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final double price;
  final List<String> imageUrl;
  final String videoUrl;
  final String quantity;
  final DateTime time;
  final String personId;
  final String personName;
  final int isAd;
  final int isOffer;
  final String category;
  bool isFavorite;

  Product({
    this.personName,
    @required this.time,
    @required this.videoUrl,
    @required this.personId,
    @required this.quantity,
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.isAd,
    @required this.isOffer,
    @required this.category,
    this.isFavorite = false,
  });

  void _setFav(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  addViewCount(String uid, String name, int rating) {
    if (uid != personId) {
      db
          .collection("Product")
          .doc(id)
          .collection("views")
          .doc(uid)
          .get()
          .then((value) {
        if (!value.exists) {
          db
              .collection("Product")
              .doc(id)
              .collection("views")
              .doc(uid)
              .set({"name": name, "rating": rating});
        }
      });
    }
  }

  Future<void> toggleFavorites(String uid) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    Map<String, dynamic> fav = {};
    await db
        .collection("Product")
        .doc(id)
        .collection("favorites")
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        db
            .collection("Product")
            .doc(id)
            .collection("favorites")
            .doc(uid)
            .delete()
            .catchError((e) {
          _setFav(oldStatus);
        });
      } else {
        fav["id"] = uid;
        db
            .collection("Product")
            .doc(id)
            .collection("favorites")
            .doc(uid)
            .set(fav)
            .catchError((e) {
          _setFav(oldStatus);
        });
      }
    });
  }
}
