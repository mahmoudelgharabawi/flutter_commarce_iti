import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_commarce/models/order_item.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:flutter_commarce/services/prefs.service.dart';

class CartProvider extends ChangeNotifier {
  List<OrderItem>? cartItems;
  final _prefrenceKey = 'cartItems';

  int itemQuantity = 1;

  void onIncreaseItemQuantity(int productId) {
    if (!checkItemInCart(productId)) {
      itemQuantity++;
      notifyListeners();
      return;
    }
    var encodedList = PrefService.preferences?.getStringList(_prefrenceKey);
    var orderItemList =
        encodedList?.map((e) => OrderItem.fromJson(jsonDecode(e))).toList();

    var updatedItem =
        orderItemList?.firstWhere((element) => element.uId == productId);

    orderItemList?.removeWhere((element) => element.uId == productId);

    updatedItem?.quantity = itemQuantity;
    updatedItem?.price =
        ((updatedItem.product?.price ?? 0) * itemQuantity).toDouble();

    orderItemList?.add(updatedItem!);

    var updateList = orderItemList?.map((e) => jsonEncode(e.toJson())).toList();

    PrefService.preferences?.setStringList(_prefrenceKey, updateList ?? []);

    getItemQuantity(productId);
    getCartProducts();
  }

  void getItemQuantity(int productId) {
    var encodedList = PrefService.preferences?.getStringList(_prefrenceKey);

    var decodedList = encodedList?.map((e) => jsonDecode(e)).toList();

    var item = decodedList?.firstWhere((element) => element['uId'] == productId,
        orElse: () => null);

    itemQuantity = (item != null) ? item['quantity'] : 1;
    notifyListeners();
  }

  bool checkItemInCart(int productId) {
    var encodedList = PrefService.preferences?.getStringList(_prefrenceKey);

    var decodedList = encodedList?.map((e) => jsonDecode(e)).toList();

    return decodedList?.any((element) => element['uId'] == productId) ?? false;
  }

  void addProductToCart(Product product) {
    var encodedList = PrefService.preferences?.getStringList(_prefrenceKey);
    var orderItem = OrderItem();
    orderItem.uId = product.id;
    orderItem.quantity = itemQuantity;
    orderItem.product = product;
    orderItem.price = (itemQuantity * (product.price ?? 0)).toDouble();
    var encodeOrderItem = jsonEncode(orderItem.toJson());
    encodedList?.add(encodeOrderItem);

    PrefService.preferences?.setStringList(_prefrenceKey, encodedList ?? []);
    getCartProducts();
  }

  void getCartProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (PrefService.preferences?.getStringList(_prefrenceKey) == null) return;

    var encodedList = PrefService.preferences
        ?.getStringList(_prefrenceKey)
        ?.map((e) => jsonDecode(e))
        .toList();

    cartItems = encodedList?.map((e) => OrderItem.fromJson(e)).toList();
    notifyListeners();
  }
}
