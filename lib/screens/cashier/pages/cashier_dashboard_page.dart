import 'package:flutter/material.dart';
import '../data/cashier_dummy_data.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/order_card_widget.dart';
import 'order_detail_page.dart';
import 'order_list_page.dart';

class CashierDashboardPage extends StatelessWidget {
  const CashierDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = CashierDummyData.statistics;
    final allOrders = CashierDummyData.orders;
    final activeOrders =
        allOrders.where((o) => o.status != OrderStatus.paid).take(3).toList();
    final recentPaid =
        allOrders.where((o) => o.status == OrderStatus.paid).take(5).toList();
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 11
        ? 'Selamat Pagi'
        : hour < 15
            ? 'Selamat Siang'
            : hour < 18
                ? 'Selamat Sore'
                : 'Selamat Malam';

    return Scaffold(
      backgroundColor: CashierTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _Header(greeting: greeting, now: now),
            ),

            // Revenue card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _RevenueCard(
                  revenue: stats['todayRevenue'] as double,
                  totalPaid: stats['totalPaid'] as int,
                ),
              ),
            ),

            // Payment method stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Metode Pembayaran Hari Ini',
                      style: TextStyle(
                        color: CashierTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _PayMethodCard(
                            label: 'QRIS',
                            count: stats['qrisCount'] as int,
                            icon: Icons.qr_code_2_rounded,
                            color: CashierTheme.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PayMethodCard(
                            label: 'Tunai',
                            count: stats['cashCount'] as int,
                            icon: Icons.payments_rounded,
                            color: CashierTheme.accentGold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PayMethodCard(
                            label: 'EDC',
                            count: stats['edcCount'] as int,
                            icon: Icons.credit_card_rounded,
                            color: CashierTheme.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Transaksi Terbaru header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Transaksi Terbaru',
                      style: TextStyle(
                        color: CashierTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderListPage(),
                        ),
                      ),
                      child: const Text(
                        'Lihat Semua →',
                        style: TextStyle(
                          color: CashierTheme.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Paid transactions list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: recentPaid.isEmpty
                  ? const SliverToBoxAdapter(
                      child: _EmptyTransactions(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _TransactionCard(
                          order: recentPaid[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OrderDetailPage(order: recentPaid[index]),
                            ),
                          ),
                        ),
                        childCount: recentPaid.length,
                      ),
                    ),
            ),

            // Pesanan Aktif header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pesanan Aktif',
                      style: TextStyle(
                        color: CashierTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderListPage(),
                        ),
                      ),
                      child: const Text(
                        'Lihat Semua →',
                        style: TextStyle(
                          color: CashierTheme.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Active orders list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              sliver: activeOrders.isEmpty
                  ? const SliverToBoxAdapter(
                      child: _EmptyActiveOrders(),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final order = activeOrders[index];
                          return OrderCardWidget(
                            order: order,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailPage(order: order),
                              ),
                            ),
                          );
                        },
                        childCount: activeOrders.length,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String greeting;
  final DateTime now;

  const _Header({required this.greeting, required this.now});

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final dateStr = '${now.day} ${months[now.month - 1]} ${now.year}';

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        color: CashierTheme.surface,
        border: Border(bottom: BorderSide(color: CashierTheme.divider)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Kasir Utama',
                style: TextStyle(
                  color: CashierTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CashierTheme.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: CashierTheme.accent.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: CashierTheme.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Online',
                      style: TextStyle(
                        color: CashierTheme.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: const TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  final double revenue;
  final int totalPaid;

  const _RevenueCard({required this.revenue, required this.totalPaid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0E00), Color(0xFF2A1800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: CashierTheme.accentGold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: CashierTheme.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: CashierTheme.accentGold,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pendapatan Hari Ini',
                  style: TextStyle(
                    color: CashierTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CashierTheme.formatCurrency(revenue),
                  style: const TextStyle(
                    color: CashierTheme.accentGold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalPaid',
                style: const TextStyle(
                  color: CashierTheme.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'transaksi',
                style: TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayMethodCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _PayMethodCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: const TextStyle(
              color: CashierTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _TransactionCard({required this.order, required this.onTap});

  Color get _methodColor {
    switch (order.paymentMethod) {
      case PaymentMethod.qris:
        return CashierTheme.accent;
      case PaymentMethod.edc:
        return CashierTheme.blue;
      case PaymentMethod.cash:
        return CashierTheme.accentGold;
      case null:
        return CashierTheme.textSecondary;
    }
  }

  IconData get _methodIcon {
    switch (order.paymentMethod) {
      case PaymentMethod.qris:
        return Icons.qr_code_rounded;
      case PaymentMethod.edc:
        return Icons.credit_card_rounded;
      case PaymentMethod.cash:
        return Icons.payments_rounded;
      case null:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeLabel = order.paidAt != null
        ? CashierTheme.formatTime(order.paidAt!)
        : CashierTheme.formatTime(order.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CashierTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: CashierTheme.success.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _methodColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(_methodIcon, color: _methodColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.id,
                        style: const TextStyle(
                          color: CashierTheme.textTertiary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: CashierTheme.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'LUNAS',
                          style: TextStyle(
                            color: CashierTheme.success,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.customerName} · Meja ${order.tableNumber}',
                    style: const TextStyle(
                      color: CashierTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CashierTheme.formatCurrency(order.totalAmount),
                  style: const TextStyle(
                    color: CashierTheme.accentGold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeLabel,
                  style: const TextStyle(
                    color: CashierTheme.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 40, color: CashierTheme.textTertiary),
          SizedBox(height: 8),
          Text(
            'Belum ada transaksi hari ini',
            style: TextStyle(color: CashierTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _EmptyActiveOrders extends StatelessWidget {
  const _EmptyActiveOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.done_all_rounded,
              size: 40, color: CashierTheme.textTertiary),
          SizedBox(height: 8),
          Text(
            'Semua pesanan sudah dibayar',
            style: TextStyle(color: CashierTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
