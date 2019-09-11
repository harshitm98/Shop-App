import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // Provider.of rebuilds the whole build method. So instead we can wrap
    // consumer against the thing that we want to change
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeNamed,
            arguments: product.id,
          );
        },
        child: GridTile(
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: Consumer<ProductProvider>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavoriteStatus();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: Consumer<Cart>(
              builder: (ctx, cart, _) => IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                  },
                  color: Theme.of(context).accentColor),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
