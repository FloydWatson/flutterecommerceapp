import 'package:flutter/material.dart';

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
  List<Product> get items{

    // Spread operator
    return [..._items];
  }

  List<Product> get favouriteItems{
    // return only favourites
    return _items.where((prodItem) => prodItem.favourite).toList();

  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

// widgets listening can see list has been edited. then call for new list at rebuild trigger
  void addProduct() {
    //_items.add(value);
    notifyListeners();
  }
}