import 'package:flutter/material.dart';
import '../../../services/firestore_service.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/order_card_widget.dart';
import 'order_detail_page.dart';
import 'order_list_page.dart';

class CashierDashboardPage extends StatelessWidget {
  const CashierDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 11
        ? 'Selamat Pagi'
        : hour < 15
            ? 'Selamat Siang'
            : hour < 18
                ? 'Selamat Sore'
                : 'Selamat Malam';

    return StreamBuilder<List<Order>>(
      stream: FirestoreService.streamCashierOrders(),
      builder: (context, snapshot) {
        final allOrders = snapshot.data ?? [];
        final stats = _calculateStatistics(allOrders);
        final activeOrders = allOrders
            .where((o) => o.status != OrderStatus.paid)
            .take(3)
            .toList();
        final recentPaid = allOrders
            .where((o) => o.status == OrderStatus.paid)
            .take(5)
            .toList();

        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Scaffold(
            backgroundColor: CashierTheme.background,
            body: Center(
              child: CircularProgressIndicator(color: CashierTheme.accent),
            ),
          );
        }

        return Scaffold(
          backgroundColor: CashierTheme.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(greeting: greeting, now: now),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _RevenueCard(
                      revenue: stats['todayRevenue'] as double,
                      totalPaid: stats['totalPaid'] as int,
                    ),
                  ),
                ),
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
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  sliver: recentPaid.isEmpty
                      ? const SliverToBoxAdapter(
                          child: _EmptyTransactions(),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => OrderCardWidget(
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
                                    builder: (_) =>
                                        OrderDetailPage(order: order),
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
      },
    );
  }

  Map<String, dynamic> _calculateStatistics(List<Order> orders) {
    final today = DateTime.now();

    final totalPaid = orders.where((o) => o.status == OrderStatus.paid).length;
    final qrisCount =
        orders.where((o) => o.paymentMethod == PaymentMethod.qris).length;
    final cashCount =
        orders.where((o) => o.paymentMethod == PaymentMethod.cash).length;
    final edcCount =
        orders.where((o) => o.paymentMethod == PaymentMethod.edc).length;
    final todayRevenue = orders
        .where((o) => o.paidAt != null && _isSameDay(o.paidAt!, today))
        .fold<double>(0, (sum, o) => sum + o.totalAmount);

    return {
      'totalPaid': totalPaid,
      'qrisCount': qrisCount,
      'cashCount': cashCount,
      'edcCount': edcCount,
      'todayRevenue': todayRevenue,
    };
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CashierTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CashierTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: CashierTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$count transaksi',
            style: const TextStyle(
              color: CashierTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Center(
        child: Text(
          'Belum ada transaksi lunas',
          style: TextStyle(color: CashierTheme.textSecondary, fontSize: 14),
        ),
      ),
    );
  }
}

class _EmptyActiveOrders extends StatelessWidget {
  const _EmptyActiveOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Center(
        child: Text(
          'Tidak ada pesanan aktif saat ini',
          style: TextStyle(color: CashierTheme.textSecondary, fontSize: 14),
        ),
      ),
    );
  }
}
