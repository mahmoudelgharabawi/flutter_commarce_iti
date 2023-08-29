import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_commarce/main.dart';
import 'package:flutter_commarce/models/order_item.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:flutter_commarce/services/prefs.service.dart';
import 'package:flutter_commarce/views/pages/home_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:http/http.dart' as http;

class CartProvider extends ChangeNotifier {
  List<OrderItem>? cartItems;
  final _prefrenceKey = 'cartItems';

  int itemQuantity = 1;

  final SimpleFontelicoProgressDialog _dialog =
      SimpleFontelicoProgressDialog(context: navigatorKey.currentContext!);

  void removeItemFromCart(int productId) async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);

    var encodedList = PrefService.preferences?.getStringList(_prefrenceKey);

    encodedList?.removeWhere(
        (econdedElement) => jsonDecode(econdedElement)['uId'] == productId);

    await PrefService.preferences
        ?.setStringList(_prefrenceKey, encodedList ?? []);

    await getCartProducts();

    _dialog.hide();
  }

  void onChangeItemQuantity(int productId, {bool decrease = false}) async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);

    if (decrease == true) {
      if (itemQuantity == 1) {
        _dialog.hide();
        return;
      }

      itemQuantity--;
    } else {
      itemQuantity++;
    }
    if (!checkItemInCart(productId)) {
      notifyListeners();
      _dialog.hide();
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

    await PrefService.preferences
        ?.setStringList(_prefrenceKey, updateList ?? []);

    getItemQuantity(productId);
    await getCartProducts();

    _dialog.hide();
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

  void addProductToCart(Product product) async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);

    var encodedList =
        PrefService.preferences?.getStringList(_prefrenceKey) ?? [];
    var orderItem = OrderItem();
    orderItem.uId = product.id;
    orderItem.quantity = itemQuantity;
    orderItem.product = product;
    orderItem.price = (itemQuantity * (product.price ?? 0)).toDouble();
    var encodeOrderItem = jsonEncode(orderItem.toJson());
    encodedList.add(encodeOrderItem);

    await PrefService.preferences?.setStringList(_prefrenceKey, encodedList);
    await getCartProducts();
    _dialog.hide();
  }

  double getTotalCartValue() {
    double totalValue = 0;
    for (var item in cartItems ?? []) {
      totalValue += (item.price ?? 0);
    }

    return totalValue;
  }

  Future<void> getCartProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (PrefService.preferences?.getStringList(_prefrenceKey) == null) return;

    var encodedList = PrefService.preferences
        ?.getStringList(_prefrenceKey)
        ?.map((e) => jsonDecode(e))
        .toList();

    cartItems = encodedList?.map((e) => OrderItem.fromJson(e)).toList();
    cartItems?.sort((a, b) => a.uId?.compareTo(b.uId ?? 0) ?? 0);
    notifyListeners();
  }

  void onBuyNowClicked() async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);
    var now = DateTime.now();

    try {
      var encodedList =
          PrefService.preferences?.getStringList(_prefrenceKey) ?? [];

      var response =
          await http.post(Uri.parse('https://fakestoreapi.com/carts'), body: {
        "date": '${now.year} - ${now.month} - ${now.day}',
        "products": jsonEncode(encodedList)
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await PrefService.preferences?.setStringList(_prefrenceKey, []);
        await getCartProducts();
        _dialog.hide();
        Alert(
            context: navigatorKey.currentContext!,
            title: "Order Done Successfully",
            type: AlertType.success,
            buttons: [
              DialogButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false),
                  child: const Text('Ok'))
            ]).show();
      } else {
        _dialog.hide();

        Alert(
            context: navigatorKey.currentContext!,
            title: "Error In Creating Order",
            desc: 'status Code : ${response.statusCode}',
            type: AlertType.error,
            buttons: [
              DialogButton(
                  onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                  child: const Text('Ok'))
            ]).show();
      }
    } catch (e) {
      _dialog.hide();

      Alert(
          context: navigatorKey.currentContext!,
          title: "Error In Creating Order",
          desc: 'error : ${e.toString()}',
          type: AlertType.error,
          buttons: [
            DialogButton(
                onPressed: () => Navigator.pop(navigatorKey.currentContext!),
                child: const Text('Ok'))
          ]).show();
    }
  }
}
