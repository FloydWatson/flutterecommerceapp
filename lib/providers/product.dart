import 'package:flutter/foundation.dart'; // used for required

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String
      imageUrl; // dont add asset as you will have to ship new app version for every product added
  bool favourite;

  Product(
      {
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.favourite = false,
      });

  void toggleFavouriteStatus(){
    this.favourite = !this.favourite;
    // telling listeners somethig has changed
    notifyListeners();
  }
}
