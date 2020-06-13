import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // getting products from parent widget.
    final product = Provider.of<Product>(context, listen: false);
    // listen false stops wodget from rebuilding when provider changes
    // getting cart from parent widget
    final cart = Provider.of<Cart>(context, listen: false);

    // when using provider of, as seen above, then the whole build method will run when data changes

    // using consumer will on re run what is wrapped inside it when it is updated.
    // this way we could have only the icon button wrapped in consumer

    return ClipRRect(
      // cliprrect used to add rounded corners. wrapping widegets that dont have border radius in these allows you to have access to border radius

      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // gesture detector allows us to make the image clickable
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            // box fit stretches image over availible space
            fit: BoxFit.cover,
          ),
        ),
        // adds bar at botom of grid tile
        footer: GridTileBar(
          // black 54 opaque black
          backgroundColor: Colors.black87,
          // leading defines widget placed on the atart of bar
          // consumer is an alternative listener.
          // child is a widget that you do not want to update on rebuild. like a static text
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              // set icon to favourite true / false
              icon: Icon(
                product.favourite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                // call proviser method to set favourite
                product.toggleFavouriteStatus();
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              // adds items to cart
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(seconds: 1),
                  action: SnackBarAction(label: 'UNDO', onPressed: () {
                    cart.removeSingleItem(product.id);
                  },),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
