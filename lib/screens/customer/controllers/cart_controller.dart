import '../models/cart_item_model.dart';

class CartController {
  static List<CartItemModel> cartItems = [];

  static void addToCart(CartItemModel item) {
    cartItems.add(item);
  }

  static void removeFromCart(CartItemModel item) {
    cartItems.remove(item);
  }

  static double totalPrice() {
    return cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );
  }
}
