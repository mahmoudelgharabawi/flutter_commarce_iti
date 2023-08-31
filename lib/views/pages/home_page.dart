import 'package:flutter/material.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:flutter_commarce/providers/cart_provider.dart';
import 'package:flutter_commarce/providers/favourite.provider.dart';
import 'package:flutter_commarce/providers/product.provider.dart';
import 'package:flutter_commarce/services/app_config.service.dart';
import 'package:flutter_commarce/views/pages/all_products_page.dart';
import 'package:flutter_commarce/views/widgets/ad_widget.dart';
import 'package:flutter_commarce/views/widgets/category_item.dart';
import 'package:flutter_commarce/views/widgets/product.widget.dart';
import 'package:flutter_commarce/views/widgets/template.widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<CartProvider>(context, listen: false).getCartProducts();
    Provider.of<FavouriteProvider>(context, listen: false)
        .getFavoriteProducts();
    Provider.of<ProductProvider>(context, listen: false).getCategories();
    Provider.of<ProductProvider>(context, listen: false).getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
      bottomNavIndex: 0,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello ${AppConfigService.currentUser?.email} ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Image.asset('assets/images/hand.png')
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Let\'s start shopping!',
              style: TextStyle(
                  color: Colors.black.withOpacity(.5),
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AdWidget(),
                  const SizedBox(
                    width: 10,
                  ),
                  AdWidget(
                    backgroundCardColor: Color(0xff1383F1),
                    btnColor: Colors.green,
                    btnTextColor: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Categories',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AllProductsPage())),
                  child: const Text(
                    'See All',
                    style: TextStyle(
                        color: Color(0xffF17547),
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            getCategoriesWidget(),
            const SizedBox(
              height: 20,
            ),
            getProductsWidget(),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget getProductsWidget() {
    if (Provider.of<ProductProvider>(context).products?.isEmpty ?? false) {
      return const Text('No Products Found');
    } else {
      return Skeletonizer(
        enabled: Provider.of<ProductProvider>(context).products == null
            ? true
            : false,
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: .7,
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: Provider.of<ProductProvider>(context)
                  .products
                  ?.map((e) => ProductWidget(product: e))
                  .toList() ??
              List.generate(6, (index) => ProductWidget(product: Product())),
        ),
      );
    }
  }

  Widget getCategoriesWidget() {
    if (Provider.of<ProductProvider>(context).categories?.isEmpty ?? false) {
      return const Text('No Categories Found');
    } else {
      return SizedBox(
        height: 65,
        child: Skeletonizer(
          enabled: Provider.of<ProductProvider>(context).categories == null
              ? true
              : false,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: Provider.of<ProductProvider>(context)
                    .categories
                    ?.map((e) => Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: CategoryItem(
                            categoryName: e,
                          ),
                        ))
                    .toList() ??
                List.generate(
                    4,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: CategoryItem(
                            categoryName: '',
                          ),
                        )),
          ),
        ),
      );
    }
  }
}
