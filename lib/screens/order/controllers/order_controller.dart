import '../../../models/order_model.dart';

class OrderController {
  static final List<OrderModel> orders = [];

  static void addOrder(OrderModel order) {
    orders.add(order);
  }

  static void updateStatus(int queueNumber, OrderStatus status) {
    final index = orders.indexWhere((o) => o.queueNumber == queueNumber);
    if (index != -1) {
      orders[index] = orders[index].copyWith(status: status);
    }
  }
}
