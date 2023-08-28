import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:flutter_commarce/providers/favourite.provider.dart';
import 'package:flutter_commarce/views/pages/product_details.page.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  const ProductWidget({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProductDetailsPage(product: product))),
      child: Container(
        height: 220,
        width: 170,
        decoration: BoxDecoration(
            color: const Color(0xffD9D9D9).withOpacity(.25),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        'sale',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () => onFavouriteClicked(context),
                      child: Provider.of<FavouriteProvider>(
                        context,
                      ).isFavourite(product.id ?? 0)
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_outline,
                            ))
                ],
              ),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: product.image ?? '',
                  placeholder: (context, url) => const SizedBox(
                      height: 15,
                      width: 15,
                      child: FittedBox(child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    product.title ?? 'No Title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black.withOpacity(.6)),
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '${product.price}\$',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black.withOpacity(.75)),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onFavouriteClicked(BuildContext context) {
    if (Provider.of<FavouriteProvider>(context, listen: false)
        .isFavourite(product.id ?? 0)) {
      Provider.of<FavouriteProvider>(context, listen: false)
          .removeProductFromFavourites(product.id ?? 0);
      return;
    }

    Provider.of<FavouriteProvider>(context, listen: false)
        .addProductToFavourites(product);
  }
}
