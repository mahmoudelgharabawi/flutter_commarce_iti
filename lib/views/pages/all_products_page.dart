import 'package:flutter/material.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:flutter_commarce/providers/product.provider.dart';
import 'package:flutter_commarce/views/widgets/product.widget.dart';
import 'package:flutter_commarce/views/widgets/template.widget.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllProductsPage extends StatefulWidget {
  final bool fromSearch;
  const AllProductsPage({this.fromSearch = false, super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateWidget(
        hideSearch: widget.fromSearch,
        showBackBtn: true,
        body: Consumer<ProductProvider>(
          builder: (BuildContext context, ProductProvider productProvider,
              Widget? child) {
            return Column(
              children: [
                if (widget.fromSearch)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) =>
                          productProvider.onAllProductsSearch(value),
                      autofocus: true,
                      decoration: InputDecoration(
                          suffixIcon: productProvider.isSearchTriggered
                              ? InkWell(
                                  onTap: () {
                                    searchController.clear();
                                    productProvider.getAllProducts();
                                  },
                                  child: const Icon(Icons.close))
                              : null,
                          label: const Text('Search'),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: const OutlineInputBorder()),
                    ),
                  ),
                Expanded(
                  child: SizedBox(
                    child: (Provider.of<ProductProvider>(context)
                                .allProducts
                                ?.isEmpty ??
                            false)
                        ? const Center(
                            child: Text('No Products Found'),
                          )
                        : Skeletonizer(
                            enabled: (Provider.of<ProductProvider>(context)
                                        .allProducts ==
                                    null
                                ? true
                                : false),
                            child: GridView.count(
                              childAspectRatio: .7,
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: Provider.of<ProductProvider>(context)
                                      .allProducts
                                      ?.map((e) => ProductWidget(product: e))
                                      .toList() ??
                                  List.generate(
                                      12,
                                      (index) =>
                                          ProductWidget(product: Product())),
                            ),
                          ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
