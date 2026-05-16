import 'addon_model.dart';

class MenuModel {
  final int id;
  final String name;
  final String image;
  final String description;
  final double price;
  final String category;
  final bool isFavorite;

  /// ADD ONS
  final List<AddOnModel> addOns;

  MenuModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.category,
    required this.isFavorite,
    required this.addOns,
  });
}