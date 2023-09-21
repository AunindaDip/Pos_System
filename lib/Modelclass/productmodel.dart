import 'package:get/get.dart';


class Product {
  final RxString name;
  final double price;
  final RxInt quantity;
  final RxInt stock;
  final RxString firebaseKey; // Add a field to store the Firebase key


  Product(this.name, this.price, this.stock, RxInt initialQuantity,this.firebaseKey)
      : quantity = initialQuantity;
}