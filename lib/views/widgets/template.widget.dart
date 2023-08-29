import 'package:flutter/material.dart';
import 'package:flutter_commarce/providers/cart_provider.dart';
import 'package:flutter_commarce/views/pages/all_products_page.dart';
import 'package:flutter_commarce/views/pages/cart_page.dart';
import 'package:flutter_commarce/views/pages/favourites_page.dart';
import 'package:flutter_commarce/views/pages/home_page.dart';
import 'package:provider/provider.dart';

class TemplateWidget extends StatelessWidget {
  final int? bottomNavIndex;
  final Widget body;
  final bool showBackBtn;
  final bool hideSearch;
  const TemplateWidget(
      {this.bottomNavIndex,
      this.showBackBtn = false,
      this.hideSearch = false,
      required this.body,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomNavIndex == null
            ? null
            : BottomNavigationBar(
                onTap: (index) => onBottomNavBArTapped(index, context),
                backgroundColor: Colors.white,
                elevation: 0,
                iconSize: 25,
                currentIndex: bottomNavIndex!,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Colors.black.withOpacity(.5),
                selectedItemColor: Color(0xffF16A26),
                items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined), label: ''),
                    BottomNavigationBarItem(
                        label: '', icon: Icon(Icons.favorite_outline)),
                    BottomNavigationBarItem(
                        label: '',
                        icon: ((Provider.of<CartProvider>(context).cartItems ==
                                    null) ||
                                (Provider.of<CartProvider>(context)
                                        .cartItems
                                        ?.isEmpty ??
                                    false))
                            ? const Icon(Icons.shopping_cart_outlined)
                            : Badge(
                                label: Text(Provider.of<CartProvider>(context)
                                    .cartItems!
                                    .length
                                    .toString()),
                                child: const Icon(Icons.shopping_cart_outlined),
                              )),
                    BottomNavigationBarItem(
                        label: '', icon: Icon(Icons.account_circle_outlined))
                  ]),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: Colors.white,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xffD9D9D9).withOpacity(.25)),
                              onPressed: showBackBtn
                                  ? () => Navigator.pop(context)
                                  : () {},
                              icon: showBackBtn
                                  ? const Icon(Icons.arrow_back_ios)
                                  : Image.asset('assets/images/drawer.png')),
                          if (!hideSearch)
                            IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const AllProductsPage(
                                              fromSearch: true,
                                            ))),
                                style: IconButton.styleFrom(
                                    backgroundColor: const Color(0xffD9D9D9)
                                        .withOpacity(.25)),
                                icon: Center(
                                  child: Image.asset(
                                    'assets/images/search.png',
                                    fit: BoxFit.cover,
                                    height: 20,
                                    width: 20,
                                  ),
                                )),
                        ],
                      ),
                    ))),
                Expanded(
                  child: body,
                ),
              ],
            ),
          ),
        ));
  }

  void onBottomNavBArTapped(int index, BuildContext context) {
    if (index == bottomNavIndex) return;
    Widget? page;
    if (index == 0) {
      page = const HomePage();
    } else if (index == 1) {
      page = const FavouritesPage();
    } else if (index == 2) {
      page = const CartPage();
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (_) => page ?? const SizedBox.shrink()));
  }
}
