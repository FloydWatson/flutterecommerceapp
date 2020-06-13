import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {

  
  // variable used to show only favourites
  final bool showFavourites;

  ProductsGrid(this.showFavourites);

  @override
  Widget build(BuildContext context) {

    // set up provider listener. change of method to tell it to listen to instance created in main
    final productsData = Provider.of<Products>(context);

    // getting product list [] from provider. or favourites list
    final products = showFavourites ? productsData.favouriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(
          10.0), // set const to make sure it does not rebuild. saves performance
      itemCount: products.length,
      // item builder is what we will see on the screen. listening to product
      // using .value as flutter recycles widgets. if we used builder method then it can cause bugs when there are more items then screen space.
      // use this .value on grids or lists. 
      // flutter will dispose of the data if done this way when screen is popped when using changeNotifier
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // products[i] returns single product item as it is stored in ProductsProvider
        value: products[i],
        child: ProductItem(
          
        ),
      ),
      // how grid will be structured. cross axis allows us to define number of coloumns, aspect ratio = bit taller then they are wide. 3 / 2
      // cross axis spacing = gutering between items, main axis spacing = space between rows
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
