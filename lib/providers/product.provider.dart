import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  List<String>? categories;
  List<Product>? products;
  List<Product>? allProducts;

  final baseProductUrl = 'https://fakestoreapi.com/products';

  String selectedCategory = "electronics";
  bool isSearchTriggered = false;

  void onAllProductsSearch(String searchValue) {
    if (searchValue.isEmpty) {
      isSearchTriggered = false;
    } else {
      allProducts = allProducts
          ?.where((element) =>
              element.title
                  ?.toLowerCase()
                  .contains(searchValue.toLowerCase()) ??
              false)
          .toList();

      isSearchTriggered = true;
    }

    notifyListeners();
  }

  void onChangeCategory(String newCategory) {
    if (selectedCategory == newCategory) return;

    selectedCategory = newCategory;
    getProducts();
    notifyListeners();
  }

  void getProducts() async {
    try {
      if (products != null) products = null;
      var response = await http
          .get(Uri.parse('${baseProductUrl}/category/${selectedCategory}'));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        products = List<Product>.from(
            jsonDecode(response.body).map((e) => Product.fromJson(e)));
      } else {
        products = [];
      }
    } catch (e) {
      products = [];
    }
    notifyListeners();
  }

  void getAllProducts() async {
    try {
      if (allProducts != null) allProducts = null;
      var response = await http.get(Uri.parse('$baseProductUrl'));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        allProducts = List<Product>.from(
            jsonDecode(response.body).map((e) => Product.fromJson(e)));
      } else {
        allProducts = [];
      }
    } catch (e) {
      allProducts = [];
    }
    notifyListeners();
  }

  void getCategories() async {
    try {
      var response = await http.get(Uri.parse('${baseProductUrl}/categories'));
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        categories = List<String>.from(jsonDecode(response.body));
      } else {
        categories = [];
      }
    } catch (e) {
      categories = [];
    }
    notifyListeners();
  }
}
