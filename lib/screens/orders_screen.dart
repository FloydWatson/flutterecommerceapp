import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      // build widget depending on what state your future is in
      body: FutureBuilder(        
        future: Provider.of<Orders>(context, listen: false)
            .fetchAndSetOrders(), // run func that returns a future. listener must be false or you risk entering a update loop when func notifies listeners. can be http request or db query. or any future you build
            // data snapshot is current data returned from future
        builder: (ctx, dataSnapshot) {
          // this is used while future hasnt resolved. future is still in process
          if (dataSnapshot.connectionState == ConnectionState.waiting) {            
            return Center(
                child: CircularProgressIndicator()); // set loading spinner
          } else {// when future has resolved         
            if (dataSnapshot.error != null) { // has error
              // error handling area
              return Center(
                child: Text('An error occurred!'),
              );
            } else {  // no error
             // set listener here using consumer
              return Consumer<Orders>(
                // build a list of the items in orderData. will automatically update as this is a listener of order provider
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
