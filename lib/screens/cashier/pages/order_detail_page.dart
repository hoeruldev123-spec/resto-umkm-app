import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../theme/cashier_theme.dart';
import '../widgets/cashier_app_bar.dart';
import 'payment_method_page.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isPaid = order.status == OrderStatus.paid;
    final canPay = order.status == OrderStatus.ready;

    return Scaffold(
      backgroundColor: CashierTheme.background,
      appBar: CashierAppBar(
        title: order.id,
        subtitle: 'Meja ${order.tableNumber} · ${order.customerName}',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrderStatusBanner(status: order.status),
                  const SizedBox(height: 20),
                  const _SectionTitle(title: 'Detail Pesanan'),
                  const SizedBox(height: 12),
                  _ItemsCard(items: order.items),
                  const SizedBox(height: 20),
                  const _SectionTitle(title: 'Rincian Pembayaran'),
                  const SizedBox(height: 12),
                  _BillCard(order: order),
                  if (isPaid) ...[
                    const SizedBox(height: 20),
                    _PaymentMethodBadge(method: order.paymentMethod),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (canPay) _PayButton(order: order),
        ],
      ),
    );
  }
}

class _OrderStatusBanner extends StatelessWidget {
  final OrderStatus status;

  const _OrderStatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    String message;
    IconData icon;

    switch (status) {
      case OrderStatus.pending:
        color = CashierTheme.warning;
        label = 'Menunggu';
        message = 'Pesanan menunggu konfirmasi dapur';
        icon = Icons.hourglass_empty_rounded;
      case OrderStatus.processing:
        color = CashierTheme.blue;
        label = 'Sedang Diproses';
        message = 'Dapur sedang menyiapkan pesanan';
        icon = Icons.restaurant_rounded;
      case OrderStatus.ready:
        color = CashierTheme.success;
        label = 'Siap Bayar';
        message = 'Pesanan siap — silakan proses pembayaran';
        icon = Icons.check_circle_rounded;
      case OrderStatus.paid:
        color = CashierTheme.textSecondary;
        label = 'Lunas';
        message = 'Pesanan telah dibayar';
        icon = Icons.done_all_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                message,
                style: const TextStyle(
                  color: CashierTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: CashierTheme.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final List<OrderItem> items;

  const _ItemsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: CashierTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${items[i].quantity}x',
                        style: const TextStyle(
                          color: CashierTheme.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].name,
                          style: const TextStyle(
                            color: CashierTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (items[i].note != null)
                          Text(
                            items[i].note!,
                            style: const TextStyle(
                              color: CashierTheme.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    CashierTheme.formatCurrency(items[i].subtotal),
                    style: const TextStyle(
                      color: CashierTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (i < items.length - 1)
              const Divider(
                  color: CashierTheme.divider, height: 1, indent: 16, endIndent: 16),
          ],
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final Order order;

  const _BillCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CashierTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _BillRow(label: 'Subtotal', value: CashierTheme.formatCurrency(order.subtotal)),
          const SizedBox(height: 10),
          _BillRow(
            label: 'PPN 10%',
            value: CashierTheme.formatCurrency(order.tax),
            valueColor: CashierTheme.textSecondary,
          ),
          const SizedBox(height: 14),
          const Divider(color: CashierTheme.divider, height: 1),
          const SizedBox(height: 14),
          _BillRow(
            label: 'Total',
            value: CashierTheme.formatCurrency(order.totalAmount),
            labelStyle: const TextStyle(
              color: CashierTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            valueColor: CashierTheme.accentGold,
            valueFontSize: 18,
          ),
        ],
      ),
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final Color? valueColor;
  final double? valueFontSize;

  const _BillRow({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueColor,
    this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: labelStyle ??
              const TextStyle(
                  color: CashierTheme.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? CashierTheme.textPrimary,
            fontSize: valueFontSize ?? 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodBadge extends StatelessWidget {
  final PaymentMethod? method;

  const _PaymentMethodBadge({this.method});

  @override
  Widget build(BuildContext context) {
    if (method == null) return const SizedBox.shrink();
    final labels = {
      PaymentMethod.qris: 'QRIS',
      PaymentMethod.edc: 'EDC / Kartu',
      PaymentMethod.cash: 'Tunai',
    };
    final icons = {
      PaymentMethod.qris: Icons.qr_code_rounded,
      PaymentMethod.edc: Icons.credit_card_rounded,
      PaymentMethod.cash: Icons.payments_rounded,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: CashierTheme.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CashierTheme.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icons[method], color: CashierTheme.success, size: 18),
          const SizedBox(width: 8),
          Text(
            'Dibayar via ${labels[method]}',
            style: const TextStyle(
                color: CashierTheme.success,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  final Order order;

  const _PayButton({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: CashierTheme.surface,
        border: Border(top: BorderSide(color: CashierTheme.divider)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Bayar',
                  style: TextStyle(
                      color: CashierTheme.textSecondary, fontSize: 13)),
              Text(
                CashierTheme.formatCurrency(order.totalAmount),
                style: const TextStyle(
                  color: CashierTheme.accentGold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaymentMethodPage(order: order),
                ),
              ),
              icon: const Icon(Icons.payment_rounded, size: 20),
              label: const Text('Proses Pembayaran'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CashierTheme.accent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
