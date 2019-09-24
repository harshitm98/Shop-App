import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

//   @override
//   _OrdersScreenState createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   var _isLoading = false;
//   @override
//   void initState() {
//     // Future.delayed(Duration.zero).then((_) async{
//     //   setState(() {
//     //     _isLoading = true;
//     //   });
//     //   await Provider.of<Orders>(context, listen: false).fetchAndSetProducts();
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     // });
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders!"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false)
              .fetchAndSetProducts(), // notifies listeners and the above listener causes the whole widget to reload and thus an infite loop is occured...
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // Handle the error..
                return Center(
                  child: Text("An error occured.."),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, ordersData, _) => ListView.builder(
                          itemCount: ordersData.orders.length,
                          itemBuilder: (ctx, i) {
                            return OrderItem(ordersData.orders[i]);
                          },
                        ));
              }
            }
          },
        ));
  }
}
