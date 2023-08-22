import 'package:pos/Modelclass/productmodel.dart';
import 'package:get/get_state_manager/get_state_manager.dart';


class CartController extends GetxController {
  var cartItems = <Product>[];


  void addToCart(Product product) {
    cartItems.add(product);
    update();
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
    update();

  }

  void clearCart() {
    cartItems.clear();
    update();

  }

  double get totalAmount {
    return cartItems.fold(0.0, (sum, product) => sum + product.price);
  }


}