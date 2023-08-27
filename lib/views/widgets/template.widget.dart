import 'package:flutter/material.dart';
import 'package:flutter_commarce/views/pages/favourites_page.dart';
import 'package:flutter_commarce/views/pages/home_page.dart';

class TemplateWidget extends StatelessWidget {
  final int? bottomNavIndex;
  final Widget body;
  const TemplateWidget({this.bottomNavIndex, required this.body, super.key});

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
                        label: '', icon: Icon(Icons.shopping_cart_outlined)),
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
                              onPressed: () {},
                              icon: Image.asset('assets/images/drawer.png')),
                          IconButton(
                              onPressed: () {},
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xffD9D9D9).withOpacity(.25)),
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
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (_) => page ?? const SizedBox.shrink()));
  }
}
