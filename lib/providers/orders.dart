
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final double amount;
  // final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    // @required this.products,
    @required this.amount,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  // Future<void> fetchAndSetOrders() async {
  //   try {
  //     final List<OrderItem> loadedProducts = [];
  //     await db.collection("Order").getDocuments().then((snapshot) {
  //       snapshot.documents.forEach((document) {
  //         loadedProducts.add(OrderItem(
  //             id: document.documentID,
  //             products: (document['products'] as List<dynamic>).map((item) {
  //               CartItem(
  //                   id: item['id'],
  //                   title: item['title'],
  //                   quantity: item['quantity'],
  //                   price: item['price'] as double);
  //             }).toList(),
  //             amount: document['amount'],
  //             dateTime: DateTime.parse(document['dateTime'])));
  //       });
  //     });
  //
  //     _orders = loadedProducts.reversed.toList();
  //   } catch (error) {
  //     throw error;
  //   }
  // }
  //
  // Future<void> addOrder(List<CartItem> cartProducts, double total) async {
  //   try {
  //     Map<String, Object> order;
  //     final timeStamp = DateTime.now();
  //     order = {
  //       'amount': total,
  //       'dateTime': timeStamp.toIso8601String(),
  //       'products': cartProducts
  //           .map((cp) => {
  //                 'id': cp.id,
  //                 'title': cp.title,
  //                 'quantity': cp.quantity,
  //                 'price': cp.price,
  //               })
  //           .toList()
  //     };
  //     await db.collection("Order").add(order).then((value) {
  //       _orders.insert(
  //           0,
  //           OrderItem(
  //               id: value.documentID,
  //               products: cartProducts,
  //               amount: total,
  //               dateTime: timeStamp));
  //     });
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
