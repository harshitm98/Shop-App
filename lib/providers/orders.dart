import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  );
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  Orders(this.authToken, this._orders);


  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = "https://flutter-firebase-226e5.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    final responseCode = await http.post(url,
        body: json.encode({
          "amount": total,
          "products": cartProducts
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
          "dateTime": timeStamp.toIso8601String(),
        }));
    if (responseCode.statusCode == 200) {
      _orders.insert(
          0,
          OrderItem(json.decode(responseCode.body)["name"], total, cartProducts,
              timeStamp));
      notifyListeners();
    }
  }

  Future<void> fetchAndSetProducts() async {
    const url = "https://flutter-firebase-226e5.firebaseio.com/orders.json";
    final response = await http.get(url);
    final List<OrderItem> loadedItems = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedItems.add(OrderItem(
        orderId,
        orderData["amount"],
        (orderData["products"] as List<dynamic>)
            .map((item) => CartItem(
                  id: item["id"],
                  price: item["price"],
                  quantity: item["quantity"],
                  title: item["title"],
                ))
            .toList(),
        DateTime.parse(orderData["dateTime"]),
      ));
    });
    _orders = loadedItems.reversed.toList();
    notifyListeners();
  }
}
