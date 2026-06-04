import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';

class OrderCardWidget extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTap,
  });

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.pending:
        return CashierTheme.warning;
      case OrderStatus.processing:
        return CashierTheme.blue;
      case OrderStatus.ready:
        return CashierTheme.success;
      case OrderStatus.paid:
        return CashierTheme.textSecondary;
    }
  }

  String get _statusLabel {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Menunggu';
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.ready:
        return 'Siap Bayar';
      case OrderStatus.paid:
        return 'Lunas';
    }
  }

  IconData get _statusIcon {
    switch (order.status) {
      case OrderStatus.pending:
        return Icons.hourglass_empty_rounded;
      case OrderStatus.processing:
        return Icons.restaurant_rounded;
      case OrderStatus.ready:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.paid:
        return Icons.done_all_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReady = order.status == OrderStatus.ready;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: CashierTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isReady
                ? CashierTheme.success.withOpacity(0.4)
                : CashierTheme.divider,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.id,
                            style: const TextStyle(
                              color: CashierTheme.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            order.customerName,
                            style: const TextStyle(
                              color: CashierTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      _StatusBadge(
                        label: _statusLabel,
                        icon: _statusIcon,
                        color: _statusColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: CashierTheme.divider, height: 1),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.table_restaurant_rounded,
                        label: 'Meja ${order.tableNumber}',
                      ),
                      const SizedBox(width: 12),
                      _InfoChip(
                        icon: Icons.receipt_long_rounded,
                        label: '${order.totalItems} item',
                      ),
                      const Spacer(),
                      Text(
                        CashierTheme.formatTime(order.createdAt),
                        style: const TextStyle(
                          color: CashierTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: CashierTheme.surface,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    CashierTheme.formatCurrency(order.totalAmount),
                    style: const TextStyle(
                      color: CashierTheme.accentGold,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isReady)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B00), Color(0xFFFF8C42)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Bayar Sekarang',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: CashierTheme.textSecondary, size: 15),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: CashierTheme.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
