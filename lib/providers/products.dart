import 'package:cloud_firestore/cloud_firestore.dart';
import 'product.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Product> _items = [];
  List<Product> _myItems = [];

  // List<Product> get items {
  //   return [..._items];
  // }

  // void setProducts(List<QueryDocumentSnapshot> myProd) {
  //   _items = myProd
  //       .map((val) => Product(
  //     time: (val['time'] as Timestamp).toDate(),
  //     id: val.id,
  //     title: val['title'],
  //     description: val['description'],
  //     price: val['price'],
  //     quantity: val['quantity'],
  //     personId: val['person_id'],
  //     personName: val['personName'],
  //     isFavorite: false,
  //     imageUrl: List<String>.from(val['imageUrl']),
  //     videoUrl: val['videoUrl'],
  //     isAd: val['isAd'],
  //     isOffer: val['isOffer'],
  //     category: val['category'],
  //   ))
  //       .toList();
  // }

  // void setMyProducts(List<QueryDocumentSnapshot> myProd) {
  //   _myItems = myProd
  //       .map((val) => Product(
  //     time: (val['time'] as Timestamp).toDate(),
  //     id: val.id,
  //     title: val['title'],
  //     description: val['description'],
  //     price: val['price'],
  //     quantity: val['quantity'],
  //     personId: val['person_id'],
  //     personName: val['personName'],
  //     isFavorite: false,
  //     imageUrl: List<String>.from(val['imageUrl']),
  //     videoUrl: val['videoUrl'],
  //     isAd: val['isAd'],
  //     isOffer: val['isOffer'],
  //     category: val['category'],
  //   ))
  //       .toList();
  // }

  // List<Product> get favoriteItems {
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }


  Product findMyViewById(String id) {
    return _myItems.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    var time = DateTime.now();
    Map<String, dynamic> data = {
      'time': time,
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'videoUrl': product.videoUrl,
      'price': product.price,
      'personName': product.personName,
      'person_id': product.personId,
      'quantity': product.quantity,
      "viewCount": 0,
      "isAd": product.isAd,
      "isOffer": product.isOffer,
      "category":product.category,
    };
    await db.collection("Product").add(data).then((value) async {
      final newProduct = Product(
        time: product.time,
        id: value.id,
        title: product.title,
        personId: product.personId,
        personName: product.personName,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        imageUrl: product.imageUrl,
        videoUrl: product.videoUrl,
        isAd: product.isAd,
        isOffer: product.isOffer,
        category: product.category
      );

      _items.add(newProduct);
      _myItems.add(newProduct);
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }


  Future<void> updateProduct(String id, Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final myProdIndex = _myItems.indexWhere((prod) => prod.id == id);

    Map<String, Object> data = {
      'time': DateTime.now(),
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'videoUrl': product.videoUrl,
      'price': product.price,
      'personName': product.personName,
      'person_id': product.personId,
      'quantity': product.quantity,
      "isAd": product.isAd,
      "isOffer": product.isOffer,
      "category":product.category
    };

    await db.collection("Product").doc(id).update(data).then((value) {
      _items[prodIndex] = product;
      _myItems[myProdIndex] = product;
      notifyListeners();
    }).catchError((e) {
      print(e);
    });
  }

  // Future<void> deleteProduct(
  //     String id, String personId, String productName) async {
  //   final existingProdIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProdIndex];
  //   _items.removeAt(existingProdIndex);
  //
  //   final myExistingProdIndex = _myItems.indexWhere((prod) => prod.id == id);
  //   var myExistingProduct = _myItems[myExistingProdIndex];
  //   _myItems.removeAt(myExistingProdIndex);
  //   notifyListeners();
  //   await db.collection("Product").doc(id).delete().catchError((e) {
  //     _items.insert(existingProdIndex, existingProduct);
  //     _myItems.insert(myExistingProdIndex, myExistingProduct);
  //     notifyListeners();
  //   });
  //
  //   existingProduct = null;
  //   myExistingProduct = null;
  // }
}
