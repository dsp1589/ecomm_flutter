import 'package:json_annotation/json_annotation.dart';

class GetProductsResponse {
  List<Category> categories;
  List<Rankings> rankings;

  GetProductsResponse({this.categories, this.rankings});

  GetProductsResponse.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Category>();
      json['categories'].forEach((v) {
        categories.add(new Category.fromJson(v));
      });
    }
    if (json['rankings'] != null) {
      rankings = new List<Rankings>();
      json['rankings'].forEach((v) {
        rankings.add(new Rankings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.rankings != null) {
      data['rankings'] = this.rankings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int id;
  String name;
  List<Product> products;
  List<int> childCategories;
  @JsonKey(ignore: true)
  List<Category> childCats;
  @JsonKey(ignore: true)
  Category parentCats;

  Category({this.id, this.name, this.products, this.childCategories});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['products'] != null) {
      products = new List<Product>();
      json['products'].forEach((v) {
        products.add(new Product.fromJson(v));
      });
    }
    childCategories = json['child_categories'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data['child_categories'] = this.childCategories;
    return data;
  }
}

class Product {
  int id;
  String name;
  String dateAdded;
  List<Variant> variants;
  Tax tax;

  Product({this.id, this.name, this.dateAdded, this.variants, this.tax});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dateAdded = json['date_added'];
    if (json['variants'] != null) {
      variants = new List<Variant>();
      json['variants'].forEach((v) {
        variants.add(new Variant.fromJson(v));
      });
    }
    tax = json['tax'] != null ? new Tax.fromJson(json['tax']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['date_added'] = this.dateAdded;
    if (this.variants != null) {
      data['variants'] = this.variants.map((v) => v.toJson()).toList();
    }
    if (this.tax != null) {
      data['tax'] = this.tax.toJson();
    }
    return data;
  }
}

class Variant {
  int id;
  String color;
  int size;
  int price;

  Variant({this.id, this.color, this.size, this.price});

  Variant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    color = json['color'];
    size = json['size'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['color'] = this.color;
    data['size'] = this.size;
    data['price'] = this.price;
    return data;
  }
}

class Tax {
  String name;
  dynamic value;

  Tax({this.name, this.value});

  Tax.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class Rankings {
  String ranking;
  List<ProductRanking> products;

  Rankings({this.ranking, this.products});

  Rankings.fromJson(Map<String, dynamic> json) {
    ranking = json['ranking'];
    if (json['products'] != null) {
      products = new List<ProductRanking>();
      json['products'].forEach((v) {
        products.add(new ProductRanking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ranking'] = this.ranking;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductRanking {
  int id;
  int viewCount;
  int orderCount;
  int shares;

  ProductRanking({this.id, this.viewCount, this.orderCount, this.shares});

  ProductRanking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    viewCount = json['view_count'];
    orderCount = json['order_count'];
    shares = json['shares'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['view_count'] = this.viewCount;
    data['order_count'] = this.orderCount;
    data['shares'] = this.shares;
    return data;
  }
}
