enum OrderStatus { pending, processing, ready, paid }

enum PaymentMethod { qris, edc, cash }

class OrderItem {
  final String name;
  final int quantity;
  final double price;
  final String? note;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.note,
  });

  double get subtotal => quantity * price;
}

class Order {
  final String id;
  final String customerName;
  final int tableNumber;
  final List<OrderItem> items;
  final DateTime createdAt;
  OrderStatus status;
  PaymentMethod? paymentMethod;

  DateTime? paidAt;

  Order({
    required this.id,
    required this.customerName,
    required this.tableNumber,
    required this.items,
    required this.createdAt,
    this.status = OrderStatus.pending,
    this.paymentMethod,
    this.paidAt,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
  double get tax => subtotal * 0.10;
  double get totalAmount => subtotal + tax;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}
