import 'addon_model.dart';
import 'menu_model.dart';

class CartItemModel {
  final MenuModel menu;
  final List<AddOnModel> selectedAddOns;
  final int quantity;
  final String note;

  CartItemModel({
    required this.menu,
    required this.selectedAddOns,
    required this.quantity,
    required this.note,
  });

  double get totalPrice {
    final addonsPrice = selectedAddOns.fold(
      0.0,
      (sum, addon) => sum + addon.price,
    );
    return (menu.price + addonsPrice) * quantity;
  }

  Map<String, dynamic> toMap() {
    final addOnsPrice =
        selectedAddOns.fold(0.0, (sum, addon) => sum + addon.price);
    return {
      'name': menu.name,
      'unitPrice': menu.price + addOnsPrice,
      'quantity': quantity,
      'note': note,
      'selectedAddOns': selectedAddOns.map((addon) => addon.toMap()).toList(),
    };
  }
}