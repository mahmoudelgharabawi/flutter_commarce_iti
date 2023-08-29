import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_commarce/main.dart';
import 'package:flutter_commarce/models/product.dart';
import 'package:flutter_commarce/services/prefs.service.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class FavouriteProvider extends ChangeNotifier {
  List<Product>? favouriteProducts;
  final _prefrenceKey = 'favouriteProducts';
  final SimpleFontelicoProgressDialog _dialog =
      SimpleFontelicoProgressDialog(context: navigatorKey.currentContext!);

  bool isFavourite(int productId) =>
      (favouriteProducts?.any((e) => e.id == productId) ?? false);

  Future<void> getFavoriteProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    if (PrefService.preferences?.getStringList(_prefrenceKey) == null) return;
    var encodedList = PrefService.preferences?.getStringList(_prefrenceKey);

    var decodedList = encodedList?.map((e) => jsonDecode(e)).toList() ?? [];
    favouriteProducts = decodedList.map((e) => Product.fromJson(e)).toList();
    notifyListeners();
  }

  void addProductToFavourites(Product product) async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);

    var encodedList =
        PrefService.preferences?.getStringList(_prefrenceKey) ?? [];
    var encodedProduct = jsonEncode(product.toJson());
    encodedList.add(encodedProduct);
    await PrefService.preferences?.setStringList(_prefrenceKey, encodedList);
    await getFavoriteProducts();

    _dialog.hide();
  }

  void removeProductFromFavourites(int id) async {
    _dialog.show(
        message: 'Loading...', type: SimpleFontelicoProgressDialogType.phoenix);

    var decodedList = PrefService.preferences
        ?.getStringList(_prefrenceKey)
        ?.map((e) => jsonDecode(e))
        .toList();

    decodedList?.removeWhere((element) => element['id'] == id);

    var encodedList = decodedList?.map((e) => jsonEncode(e)).toList();
    await PrefService.preferences
        ?.setStringList(_prefrenceKey, encodedList ?? []);

    await getFavoriteProducts();
    _dialog.hide();
  }
}
