import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  var isFav = false;
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favourites) {
                // productsContainer.showFavoritesOnly();
                setState(() {
                  widget.isFav = true;
                });
              } else if (selectedValue == FilterOptions.All) {
                // productsContainer.showAll();
                setState(() {
                  widget.isFav = false;
                });
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favourites"),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show all"),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ), // So that this part of consumer is not rebuilt
          )
        ],
      ),
      body: new ProductsGrid(widget.isFav),
    );
  }
}
