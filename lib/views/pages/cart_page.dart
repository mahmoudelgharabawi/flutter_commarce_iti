import 'package:flutter/material.dart';
import 'package:flutter_commarce/providers/cart_provider.dart';
import 'package:flutter_commarce/views/widgets/cart_item.widget.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartProvider>(
        builder:
            (BuildContext context, CartProvider cartProvider, Widget? child) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 70,
                  ),
                  Positioned(
                    top: 25,
                    left: 7,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios)),
                  ),
                  Positioned.fill(
                      bottom: 7,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'My Cart',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          )))
                ],
              ),
              Expanded(
                  child: ((cartProvider.cartItems == null) ||
                          (cartProvider.cartItems?.isEmpty ?? false))
                      ? Center(
                          child: const Text('No Items In Your Cart'),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: cartProvider.cartItems!
                              .map((e) => CartItemWidget(orderItem: e))
                              .toList(),
                        )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        Text(
                          '\$${Provider.of<CartProvider>(context).getTotalCartValue().truncate()}',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Color(0xffF16A26)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: ((cartProvider.cartItems == null) ||
                              (cartProvider.cartItems?.isEmpty ?? false))
                          ? null
                          : () => cartProvider.onBuyNowClicked(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF16A26),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize: const Size(double.maxFinite, 45)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Buy Now'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}
