import 'package:flutter/foundation.dart'; // used for required

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String
      imageUrl; // dont add asset as you will have to ship new app version for every product added
  bool isFavorite;

  Product(
      {
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false,
      });

  void toggleFavouriteStatus(){
    this.isFavorite = !this.isFavorite;
    // telling listeners somethig has changed
    notifyListeners();
  }
}
