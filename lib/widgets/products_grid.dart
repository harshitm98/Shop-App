import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './products_item.dart';

class ProductsGrid extends StatelessWidget {

  final isFav;

  ProductsGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = isFav ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        // builder: (ctx1) => products[index], // No need to instantiate now, because already instantiating ProductProvider inside ProductsProvider
        child: ProductItem(
          // products[index].id,
          // products[index].title,
          // products[index].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
