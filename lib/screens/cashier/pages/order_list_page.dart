import 'package:flutter/material.dart';
import '../data/cashier_dummy_data.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/cashier_app_bar.dart';
import '../widgets/order_card_widget.dart';
import 'order_detail_page.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  OrderStatus? _filter;

  List<Order> get _filtered {
    final all = CashierDummyData.orders;
    if (_filter == null) return all;
    return all.where((o) => o.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: CashierAppBar(
        title: 'Daftar Pesanan',
        subtitle: '${CashierDummyData.orders.length} total pesanan',
      ),
      body: Column(
        children: [
          _FilterBar(
            selected: _filter,
            onSelected: (status) => setState(() => _filter = status),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final order = _filtered[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final OrderStatus? selected;
  final ValueChanged<OrderStatus?> onSelected;

  const _FilterBar({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const filters = <String, OrderStatus?>{
      'Semua': null,
      'Menunggu': OrderStatus.pending,
      'Diproses': OrderStatus.processing,
      'Siap Bayar': OrderStatus.ready,
      'Lunas': OrderStatus.paid,
    };

    return Container(
      height: 52,
      color: CashierTheme.surface,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: filters.entries.map((e) {
          final isActive = selected == e.value;
          return GestureDetector(
            onTap: () => onSelected(e.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? CashierTheme.accent : CashierTheme.card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? CashierTheme.accent
                      : CashierTheme.divider,
                ),
              ),
              child: Center(
                child: Text(
                  e.key,
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : CashierTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 56, color: CashierTheme.textTertiary),
          SizedBox(height: 12),
          Text(
            'Tidak ada pesanan',
            style: TextStyle(color: CashierTheme.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
