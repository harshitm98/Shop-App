import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class ProductProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    // Optimisically updating..
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        "https://flutter-firebase-226e5.firebaseio.com/products/$id.json";

    final response = await http.patch(url,
        body: json.encode(
          {
            "isFavorite": isFavorite,
          },
        ));
    
    if(response.statusCode >= 400){
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException("Could not update favorite...");
    }
  }
}
