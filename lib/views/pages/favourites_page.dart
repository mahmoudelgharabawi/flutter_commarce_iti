import 'package:flutter/material.dart';
import 'package:flutter_commarce/providers/favourite.provider.dart';
import 'package:flutter_commarce/views/widgets/product.widget.dart';
import 'package:flutter_commarce/views/widgets/template.widget.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
      bottomNavIndex: 1,
      body:
          (Provider.of<FavouriteProvider>(context).favouriteProducts == null ||
                  (Provider.of<FavouriteProvider>(context)
                          .favouriteProducts
                          ?.isEmpty ??
                      false))
              ? const Center(
                  child: Text('No Favourite Products'),
                )
              : GridView.count(
                  childAspectRatio: .7,
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: Provider.of<FavouriteProvider>(context)
                          .favouriteProducts
                          ?.map((e) => ProductWidget(product: e))
                          .toList() ??
                      [],
                ),
    );
  }
}
