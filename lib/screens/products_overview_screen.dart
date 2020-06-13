import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

import '../screens/cart_screen.dart';
import '../providers/cart.dart';

enum FilterOptions {
  Favoutires,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;



  @override
  Widget build(BuildContext context) {

    
    //final cart = Provider.of<Cart>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          // menu that opens up as an overlay
          // icon is display. item builder builds entries
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onSelected: (FilterOptions selectedValue) {
              // needs to be in setState or ui wont update
              setState(() {
                if (selectedValue == FilterOptions.Favoutires) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            itemBuilder: (_) => [
              // needs to return a list of widgets
              // value is used as what was chosen
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favoutires,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          // ch is child defined below. button wont be rebuilt when cart changes
          Consumer<Cart>(builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
           child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                // navigating to cart screen
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
            ),
        ],
      ),
      drawer: AppDrawer(),
      // grid view here only renders objects on scrren at the time
      body: ProductsGrid(_showOnlyFavourites),
    );
  }
}
