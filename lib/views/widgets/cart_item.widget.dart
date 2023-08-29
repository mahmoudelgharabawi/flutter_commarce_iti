import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commarce/models/order_item.dart';
import 'package:flutter_commarce/providers/cart_provider.dart';
import 'package:flutter_commarce/views/pages/product_details.page.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  const CartItemWidget({required this.orderItem, super.key});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context, listen: false)
          .getItemQuantity(widget.orderItem.product?.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProductDetailsPage(
                        product: widget.orderItem.product!))),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xffF8F8F8),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: 130,
                      height: 100,
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        imageUrl: widget.orderItem.product?.image ?? '',
                        placeholder: (context, url) => const SizedBox(
                            height: 15,
                            width: 15,
                            child:
                                FittedBox(child: CircularProgressIndicator())),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.orderItem.product?.title ?? 'No Title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$${widget.orderItem.price.toString()}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 13),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () =>
                                      cartProvider.removeItemFromCart(
                                          widget.orderItem.product?.id ?? 0),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: .8,
                                        color: const Color(0xffF16A26))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 6),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () =>
                                            cartProvider.onChangeItemQuantity(
                                                widget.orderItem.product?.id ??
                                                    0,
                                                decrease: true),
                                        child: Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: const Color(0xffF16A26),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Text(widget.orderItem.quantity
                                            .toString()),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            cartProvider.onChangeItemQuantity(
                                                widget.orderItem.product?.id ??
                                                    0),
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: const Color(0xffF16A26),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
