import '../models/order_model.dart';

class CashierDummyData {
  static List<Order> get orders => [
        Order(
          id: 'ORD-001',
          customerName: 'Budi Santoso',
          tableNumber: 3,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          status: OrderStatus.ready,
          items: const [
            OrderItem(name: 'Nasi Goreng Spesial', quantity: 2, price: 25000),
            OrderItem(name: 'Es Teh Manis', quantity: 2, price: 8000),
            OrderItem(name: 'Kerupuk', quantity: 1, price: 5000),
          ],
        ),
        Order(
          id: 'ORD-002',
          customerName: 'Siti Rahayu',
          tableNumber: 7,
          createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
          status: OrderStatus.processing,
          items: const [
            OrderItem(name: 'Ayam Bakar', quantity: 1, price: 35000),
            OrderItem(name: 'Nasi Putih', quantity: 1, price: 5000),
            OrderItem(name: 'Jus Alpukat', quantity: 1, price: 15000),
            OrderItem(name: 'Tempe Goreng', quantity: 2, price: 7000),
          ],
        ),
        Order(
          id: 'ORD-003',
          customerName: 'Ahmad Fauzi',
          tableNumber: 1,
          createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
          status: OrderStatus.pending,
          items: const [
            OrderItem(name: 'Soto Ayam', quantity: 3, price: 22000),
            OrderItem(name: 'Emping', quantity: 3, price: 5000),
            OrderItem(name: 'Air Mineral', quantity: 3, price: 5000, note: 'Tanpa sedotan'),
          ],
        ),
        Order(
          id: 'ORD-004',
          customerName: 'Dewi Lestari',
          tableNumber: 5,
          createdAt: DateTime.now().subtract(const Duration(minutes: 55)),
          status: OrderStatus.paid,
          paymentMethod: PaymentMethod.qris,
          paidAt: DateTime.now().subtract(const Duration(minutes: 40)),
          items: const [
            OrderItem(name: 'Mie Goreng', quantity: 2, price: 20000),
            OrderItem(name: 'Sate Ayam', quantity: 1, price: 30000),
            OrderItem(name: 'Es Jeruk', quantity: 2, price: 10000),
          ],
        ),
        Order(
          id: 'ORD-005',
          customerName: 'Rudi Hermawan',
          tableNumber: 9,
          createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
          status: OrderStatus.ready,
          items: const [
            OrderItem(name: 'Gado-Gado', quantity: 2, price: 18000),
            OrderItem(name: 'Bakso Mercon', quantity: 1, price: 25000, note: 'Pedas level 3'),
            OrderItem(name: 'Es Campur', quantity: 2, price: 12000),
          ],
        ),
        Order(
          id: 'ORD-006',
          customerName: 'Linda Cahaya',
          tableNumber: 2,
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
          status: OrderStatus.paid,
          paymentMethod: PaymentMethod.cash,
          paidAt: DateTime.now().subtract(const Duration(hours: 1)),
          items: const [
            OrderItem(name: 'Rendang', quantity: 1, price: 40000),
            OrderItem(name: 'Nasi Putih', quantity: 2, price: 5000),
            OrderItem(name: 'Sayur Asem', quantity: 1, price: 10000),
            OrderItem(name: 'Es Teh Manis', quantity: 2, price: 8000),
          ],
        ),
        Order(
          id: 'ORD-007',
          customerName: 'Hendra Wijaya',
          tableNumber: 4,
          createdAt: DateTime.now().subtract(const Duration(minutes: 3)),
          status: OrderStatus.pending,
          items: const [
            OrderItem(name: 'Nasi Uduk', quantity: 2, price: 18000),
            OrderItem(name: 'Ayam Goreng', quantity: 2, price: 25000),
            OrderItem(name: 'Sambal', quantity: 2, price: 3000),
            OrderItem(name: 'Kopi Susu', quantity: 2, price: 15000),
          ],
        ),
        Order(
          id: 'ORD-008',
          customerName: 'Budi Pratama',
          tableNumber: 6,
          createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
          status: OrderStatus.paid,
          paymentMethod: PaymentMethod.edc,
          paidAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
          items: const [
            OrderItem(name: 'Ikan Bakar', quantity: 2, price: 45000),
            OrderItem(name: 'Nasi Putih', quantity: 2, price: 5000),
            OrderItem(name: 'Es Kelapa Muda', quantity: 2, price: 15000),
          ],
        ),
        Order(
          id: 'ORD-009',
          customerName: 'Rina Susanti',
          tableNumber: 8,
          createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
          status: OrderStatus.paid,
          paymentMethod: PaymentMethod.qris,
          paidAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
          items: const [
            OrderItem(name: 'Sate Padang', quantity: 10, price: 3500),
            OrderItem(name: 'Lontong', quantity: 2, price: 5000),
            OrderItem(name: 'Es Teh Manis', quantity: 2, price: 8000),
          ],
        ),
        Order(
          id: 'ORD-010',
          customerName: 'Agus Setiawan',
          tableNumber: 10,
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          status: OrderStatus.paid,
          paymentMethod: PaymentMethod.cash,
          paidAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
          items: const [
            OrderItem(name: 'Nasi Campur', quantity: 3, price: 22000),
            OrderItem(name: 'Bakwan', quantity: 3, price: 4000),
            OrderItem(name: 'Jus Mangga', quantity: 3, price: 12000),
          ],
        ),
      ];

  static Map<String, dynamic> get statistics => {
        'totalPaid': 18,
        'qrisCount': 8,
        'cashCount': 6,
        'edcCount': 4,
        'todayRevenue': 1285000.0,
        'activeOrders': 4,
      };
}
