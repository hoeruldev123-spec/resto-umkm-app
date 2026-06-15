class AddOnModel {
  final String name;
  final double price;

  AddOnModel({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
    };
  }

  factory AddOnModel.fromMap(Map<String, dynamic> map) {
    return AddOnModel(
      name: map['name']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '0') ?? 0,
    );
  }
}
