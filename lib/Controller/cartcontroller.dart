import 'package:pos/Modelclass/productmodel.dart';
import 'package:get/get.dart';



class CartController extends GetxController {
  var cartItems = <Product>[].obs;

  RxDouble discount = RxDouble(0.0); // Initialize with no discount




  bool addToCart(Product product, int quantity) {
    var existingProductIndex = cartItems.indexWhere(
          (item) => item.name == product.name,
    );

    if (existingProductIndex != -1) {
      cartItems[existingProductIndex].quantity.value += quantity;
      return false; // Product is already in the cart
    } else {
      product.quantity.value = quantity;
      cartItems.add(product);
      return true; // Product added successfully
    }
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  void clearCart() {
    cartItems.clear();
  }
  void setDiscount(double value) {
    discount.value = value;
  }


  double get totalAmount {
    return cartItems.fold(0.0,
            (sum, product) => sum + (product.price * product.quantity.value));
  }


  double get afterdiscount {
    double subtotal = cartItems.fold(0.0,
            (sum, product) => sum + (product.price * product.quantity.value));
    return subtotal - discount.value; // Convert RxDouble to double// Subtract discount from the subtotal
  }

}  RxDouble discount = RxDouble(0.0); // Initialize with no discount
