import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product_provider.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<ProductProvider> _items = [
    // ProductProvider(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // ProductProvider(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // ProductProvider(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // ProductProvider(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  ProductProvider findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // var _showFavoritesOnly = false;

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<ProductProvider> get items {
    // Returns copy of items. To avoid direct editing. So that when we want to change the value
    // we can do that so by creating a function and then notifying all the listeners and thus
    // all the widgets

    // if(_showFavoritesOnly){
    //   return _items.where((item) => item.isFavorite).toList();
    // }

    return [..._items];
  }

  List<ProductProvider> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = "https://flutter-firebase-226e5.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extarctedData = json.decode(response.body) as Map<String, dynamic>;
      final List<ProductProvider> loadedProducts = [];
      if(extarctedData == null){
        return;
      }
      extarctedData.forEach((prodId, value) {
        loadedProducts.add(ProductProvider(
          id: prodId,
          title: value["title"],
          description: value["description"],
          price: value["price"],
          isFavorite: value["isFavorite"],
          imageUrl: value["imageUrl"],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProducts(ProductProvider product) async {
    const url = "https://flutter-firebase-226e5.firebaseio.com/products.json";
    // Returns Future<void> ie http.then(..) is returned
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorite": product.isFavorite,
        }),
      );
      print(json.decode(response.body));
      print(json.decode(response.statusCode.toString()));
      final newProduct = ProductProvider(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
  // print(error);
  // throw error;

  Future<void> updateProduct(String id, ProductProvider newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://flutter-firebase-226e5.firebaseio.com/products/$id.json";
      await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "descripiton": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    // Optimising Updating..
    final url =
        "https://flutter-firebase-226e5.firebaseio.com/products/$id.json";
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }

    existingProduct = null;
  }
}
