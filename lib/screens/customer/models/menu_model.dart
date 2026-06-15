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

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0,
      category: map['category']?.toString() ?? '',
      isFavorite: map['isFavorite'] == true ||
          map['isFavorite']?.toString().toLowerCase() == 'true',
      addOns: (map['addOns'] as List<dynamic>?)
              ?.map((item) => AddOnModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'price': price,
      'category': category,
      'isFavorite': isFavorite,
      'addOns': addOns.map((addon) => addon.toMap()).toList(),
    };
  }
}
