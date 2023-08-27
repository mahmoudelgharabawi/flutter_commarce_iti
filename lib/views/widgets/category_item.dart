import 'package:flutter/material.dart';
import 'package:flutter_commarce/providers/product.provider.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoryItem extends StatelessWidget {
  final String categoryName;
  const CategoryItem({required this.categoryName, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (BuildContext context, ProductProvider productProvider,
          Widget? child) {
        return InkWell(
          onTap: () => productProvider.onChangeCategory(categoryName),
          child: Container(
            width: 65,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffD9D9D9)),
                color: productProvider.selectedCategory == categoryName
                    ? const Color(0xffF17547)
                    : Color(0xffD9D9D9).withOpacity(.25),
                borderRadius: BorderRadius.circular(10)),
            child: Skeleton.replace(
              child: Center(
                child: Icon(
                  getIcon(),
                  size: 30,
                  color: productProvider.selectedCategory == categoryName
                      ? Colors.white
                      : Colors.black.withOpacity(.5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData getIcon() {
    switch (categoryName) {
      case 'electronics':
        return LineAwesome.laptop_solid;
      case 'jewelery':
        return LineAwesome.gem;
      case 'men\'s clothing':
        return LineAwesome.tshirt_solid;
      case 'women\'s clothing':
        return Icons.woman;

      default:
        return Icons.no_backpack;
    }
  }
}
