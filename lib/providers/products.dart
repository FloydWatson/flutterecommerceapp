import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  // underscore = private property
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // if just list is returned then you get a pointer to that list, a Reference of it
  List<Product> get items {
    // Spread operator
    return [..._items];
  }

  List<Product> get favouriteItems {
    // return only favourites
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

// widgets listening can see list has been edited. then call for new list at rebuild trigger
 Future<void> addProduct(Product product) {
    const url = 'https://flutter-update-b197f.firebaseio.com/products.json';
    // return future for loading trigger. this is returning the result of then as it is the last future created
    return http
        .post(
      url,
      // add headers here
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((response) {
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      
      notifyListeners();
    }).catchError((error) {
      print(error);
      // throw built into dart. will create new error. we use this so a error can be passed to screen to use in logic
      throw error;
    });
    // catch errors from post or then. dont put before then or you will run then after err logic

    
  }

  void updateProduct(String id, Product product) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    _items[prodIndex] = product;
    notifyListeners();
  }

  void deleteProduct(String id){
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
