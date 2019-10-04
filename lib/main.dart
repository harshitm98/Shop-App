import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth-screen.dart';
import './screens/edit_product_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders.dart';
import './providers/auth_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Using the value makes sure that listener is attached to data and does not mess up in huge ListViews and GridViews
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // So that we can pass auth.token ie from one provider to another provider
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          // builder: ( previousData == null ? [] : ctx) => ProductsProvider(),
          builder: (ctx, auth, previousProduct) => ProductsProvider(
            auth.token,
            previousProduct == null ? [] : previousProduct.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousData) => Orders(
              auth.token, previousData == null ? [] : previousData.orders),
        ),
      ],
      // This ensures that the MaterialApp is rebuilt whenever the auth changes...
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
          ),
          home: authData.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Text("Test"),
    );
  }
}
