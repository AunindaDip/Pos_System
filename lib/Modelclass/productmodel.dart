import 'package:get/get.dart';


class Product {
  final String name;
  final double price;
  final RxInt quantity;
  final RxInt stock;

  Product(this.name, this.price, this.stock, RxInt initialQuantity)
      : quantity = initialQuantity;
}