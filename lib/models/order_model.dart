import '../screens/customer/models/cart_item_model.dart';

enum OrderStatus { menunggu, diproses, selesai }

class OrderModel {
  final String customerName;
  final String tableNumber;
  final List<CartItemModel> items;
  final int queueNumber;
  final double totalPrice;
  final OrderStatus status;

  OrderModel({
    required this.customerName,
    required this.tableNumber,
    required this.items,
    required this.queueNumber,
    required this.totalPrice,
    this.status = OrderStatus.menunggu,
  });

  OrderModel copyWith({OrderStatus? status}) {
    return OrderModel(
      customerName: customerName,
      tableNumber: tableNumber,
      items: items,
      queueNumber: queueNumber,
      totalPrice: totalPrice,
      status: status ?? this.status,
    );
  }
}
