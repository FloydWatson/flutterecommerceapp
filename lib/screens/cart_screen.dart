import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// show lets dart know we are only interested in that part of the package
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  // route
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    // getting cart provider
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                // adding space between elements
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // spacer allows us to push space between widgets. it takes up all available space between
                  Spacer(),
                  // element with rounded corners used to display information
                  Chip(
                    label: Text(
                      // getting total from cart provider. to string is automatic. backslash dollar is to escape string and show dollar sign
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                      cart.clear();
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // need expanded as list view does not work inside colomn. expanded makes sure it takes as much space as is left inside widget
          Expanded(
            // builder allows for an infinite amount of items
            child: ListView.builder(
              // needs item count and item builder
              // count is just how many items need to be rendered
              itemCount: cart.itemCount,
              // tells us what needs to be built for each item
              // need show for this as there is two instances of CartItem imported
              itemBuilder: (ctx, i) => CartItem(
                // without .values.toList we are getting a map returned. this cannot give us the functionality we need
                // adding .values.toList goves us an itterable that does allow us acces using index
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
