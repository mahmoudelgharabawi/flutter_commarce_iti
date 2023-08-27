class Product {
  int? id;
  String? title;
  num? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;
  Product();
  Product.fromJson(Map<String, dynamic> jsonData) {
    id = jsonData['id'];
    title = jsonData['title'];
    price = jsonData['price'];
    description = jsonData['description'];
    category = jsonData['category'];
    image = jsonData['image'];
    rating = Rating.fromJson(jsonData['rating']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
        "rating": rating?.toJson(),
      };
}

class Rating {
  num? rate;
  int? count;
  Rating.fromJson(Map<String, dynamic> data) {
    rate = data['rate'];
    count = data['count'];
  }

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'count': count,
      };
}
