import 'package:flutter_commarce/models/product.dart';

class OrderItem {
  int? uId;
  int? quantity;
  double? price;
  Product? product;

  OrderItem();

  OrderItem.fromJson(Map<String, dynamic> data) {
    uId = data['uId'];
    quantity = data['quantity'];
    price = data['price'];
    product = Product.fromJson(data['product']);
  }

  Map<String, dynamic> toJson() {
    return {
      "uId": uId,
      "quantity": quantity,
      "price": price,
      "product": product?.toJson(),
    };
  }
}
