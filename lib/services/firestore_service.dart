import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import '../screens/cashier/models/order_model.dart' as cashier_model;
import '../screens/customer/models/menu_model.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference get _orders => _db.collection('orders');
  static CollectionReference get _menus => _db.collection('menus');

  static Future<void> saveCustomerOrder(OrderModel order) async {
    try {
      await _orders.add({
        'customerName': order.customerName,
        'tableNumber': order.tableNumber,
        'queueNumber': order.queueNumber,
        'totalPrice': order.totalPrice,
        'status': _customerStatusToFirestoreString(order.status),
        'createdAt': Timestamp.now(),
        'items': order.items.map((item) => item.toMap()).toList(),
      });
    } catch (e) {
      print('ERROR FIRESTORE SAVE ORDER: $e');
      rethrow;
    }
  }

  static Future<void> updateCustomerOrderStatus(
      int queueNumber, OrderStatus status) async {
    try {
      final snapshot = await _orders
          .where('queueNumber', isEqualTo: queueNumber)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({
          'status': _customerStatusToFirestoreString(status),
        });
      }
    } catch (e) {
      print('ERROR FIRESTORE UPDATE ORDER STATUS: $e');
    }
  }

  static Future<List<MenuModel>> fetchMenus() async {
    try {
      final snapshot = await _menus.orderBy('name').get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) =>
                MenuModel.fromMap(Map<String, dynamic>.from(doc.data() as Map)))
            .toList();
      }

      final fallbackSnapshot =
          await _db.collection('menu').orderBy('name').get();
      if (fallbackSnapshot.docs.isNotEmpty) {
        return fallbackSnapshot.docs
            .map((doc) =>
                MenuModel.fromMap(Map<String, dynamic>.from(doc.data() as Map)))
            .toList();
      }

      return [];
    } catch (e) {
      print('ERROR FIRESTORE FETCH MENUS: $e');
      return [];
    }
  }

  static Future<void> testConnection() async {
    try {
      await _db.collection('ping').doc('status').get();
    } catch (e) {
      print('ERROR FIRESTORE TEST CONNECTION: $e');
      rethrow;
    }
  }

  static Stream<List<cashier_model.Order>> streamCashierOrders() {
    return _orders.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return cashier_model.Order(
              id: doc.id,
              customerName: data['customerName']?.toString() ?? '-',
              tableNumber:
                  int.tryParse(data['tableNumber']?.toString() ?? '0') ?? 0,
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              status: _cashierStatusFromString(
                  data['status']?.toString() ?? 'pending'),
              paymentMethod:
                  _paymentMethodFromString(data['paymentMethod']?.toString()),
              paidAt: (data['paidAt'] as Timestamp?)?.toDate(),
              items: _orderItemsFromList(data['items'] as List<dynamic>?),
            );
          }).toList(),
        );
  }

  static Future<void> updateCashierOrderPayment({
    required String orderId,
    required cashier_model.PaymentMethod paymentMethod,
  }) async {
    try {
      await _orders.doc(orderId).update({
        'status': 'paid',
        'paymentMethod': paymentMethod.name,
        'paidAt': Timestamp.now(),
      });
    } catch (e) {
      print('ERROR FIRESTORE UPDATE CASHIER PAYMENT: $e');
    }
  }

  static Future<void> updateCashierOrderStatus({
    required String orderId,
    required cashier_model.OrderStatus status,
  }) async {
    try {
      await _orders.doc(orderId).update({
        'status': status.name,
      });
    } catch (e) {
      print('ERROR FIRESTORE UPDATE CASHIER ORDER STATUS: $e');
    }
  }

  static Stream<OrderStatus> streamCustomerOrderStatus(int queueNumber) {
    return _orders
        .where('queueNumber', isEqualTo: queueNumber)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return OrderStatus.menunggu;
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      return _customerStatusFromFirestoreString(
          data['status']?.toString() ?? 'pending');
    });
  }

  static String _customerStatusToFirestoreString(OrderStatus status) {
    switch (status) {
      case OrderStatus.menunggu:
        return 'pending';
      case OrderStatus.diproses:
        return 'processing';
      case OrderStatus.selesai:
        return 'ready';
    }
  }

  static OrderStatus _customerStatusFromFirestoreString(String value) {
    switch (value) {
      case 'processing':
        return OrderStatus.diproses;
      case 'ready':
        return OrderStatus.selesai;
      case 'pending':
      default:
        return OrderStatus.menunggu;
    }
  }

  static cashier_model.OrderStatus _cashierStatusFromString(String value) {
    switch (value) {
      case 'pending':
        return cashier_model.OrderStatus.pending;
      case 'processing':
        return cashier_model.OrderStatus.processing;
      case 'ready':
        return cashier_model.OrderStatus.ready;
      case 'paid':
        return cashier_model.OrderStatus.paid;
      default:
        return cashier_model.OrderStatus.pending;
    }
  }

  static cashier_model.PaymentMethod? _paymentMethodFromString(String? value) {
    switch (value) {
      case 'qris':
        return cashier_model.PaymentMethod.qris;
      case 'edc':
        return cashier_model.PaymentMethod.edc;
      case 'cash':
        return cashier_model.PaymentMethod.cash;
      default:
        return null;
    }
  }

  static List<cashier_model.OrderItem> _orderItemsFromList(
      List<dynamic>? items) {
    if (items == null) return [];
    return items.map((item) {
      final data = item as Map<String, dynamic>;
      return cashier_model.OrderItem(
        name: data['name']?.toString() ?? '-',
        quantity: int.tryParse(data['quantity']?.toString() ?? '0') ?? 0,
        price: double.tryParse(data['unitPrice']?.toString() ?? '0') ?? 0,
        note: data['note']?.toString(),
      );
    }).toList();
  }
}
