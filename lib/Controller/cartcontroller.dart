import 'package:pos/Modelclass/productmodel.dart';
import 'package:get/get.dart';



class CartController extends GetxController {
  var cartItems = List<Product>.empty(growable: true).toList().obs;


  RxDouble discount = RxDouble(0.0); // Initialize with no discount
  RxDouble Paidammount  = RxDouble(0.0); // Initialize with no discount
  RxInt get length => cartItems.length.obs;
  RxDouble afterPaid = RxDouble(0.0); // Define afterPaid as an RxDouble





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

    update();
  }

  void clearCart() {
    cartItems.clear();
  }
  void setDiscount(double value) {
    discount.value = value;
  }
  void setPaidammount(double value) {
    Paidammount.value = value;
  }
  void setAfterPaid(double value) {
    afterPaid.value = value;
  }



  double get totalAmount {
    return cartItems.fold(0.0,
            (sum, product) => sum + (product.price * product.quantity.value));
  }


  double get afterdiscount {


    return totalAmount - discount.value; // Convert RxDouble to double// Subtract discount from the subtotal
  }

  double get afterpaid {

    return afterdiscount - Paidammount.value; // Convert RxDouble to double// Subtract discount from the subtotal
  }




}